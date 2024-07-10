package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
	"path"
	"regexp"
	"time"

	"github.com/charmbracelet/lipgloss"
)

func main() {
	// api, err := NewAPI()
	// if err != nil {
	// 	log.Fatalln(err)
	// }
	// value, err := api.ReleasesLatest("nushell/nushell")
	// value, err := api.RateLimit()
	// if err != nil {
	// 	log.Fatalln(err)
	// }
	// fmt.Printf("%+v\n", value)

	err := Update()
	if err != nil {
		log.Fatalln(err)
	}
}

type API struct {
	client *http.Client
}

func NewAPI() (*API, error) {
	client := &http.Client{}
	return &API{client}, nil
}

func (s *API) do(base string) ([]byte, error) {
	u, err := url.Parse("https://api.github.com")
	if err != nil {
		return nil, err
	}
	u.Path = path.Join(u.Path, base)

	req, err := http.NewRequest("GET", u.String(), nil)
	req.Header.Add("Accept", "application/vnd.github+json")
	req.Header.Add("X-GitHub-Api-Version", "2022-11-28")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	// fmt.Println(string(body))
	return body, nil
}

type Resource struct {
	Limit     int    `json:"limit"`
	Remaining int    `json:"remaining"`
	Reset     int64  `json:"reset"`
	Used      int    `json:"used"`
	Resource  string `json:"resource"`
}

type Resources struct {
	Core                Resource `json:"core"`
	Graphql             Resource `json:"graphql"`
	IntegrationManifest Resource `json:"integration_manifest"`
	Search              Resource `json:"search"`
	Rate                Resource `json:"rate"`
}

type RateLimit struct {
	Resources Resources `json:"resources"`
}

func (s *API) RateLimit() (*RateLimit, error) {
	bytes, err := s.do("rate_limit")
	if err != nil {
		return nil, err
	}
	value := new(RateLimit)
	if err = json.Unmarshal(bytes, value); err != nil {
		return nil, err
	}
	return value, nil
}

type ReleasesLatest struct {
	URL             string    `json:"url"`
	AssetsURL       string    `json:"assets_url"`
	UploadURL       string    `json:"upload_url"`
	HTMLURL         string    `json:"html_url"`
	ID              int64     `json:"id"`
	NodeID          string    `json:"node_id"`
	TagName         string    `json:"tag_name"`
	TargetCommitish string    `json:"target_commitish"`
	Name            string    `json:"name"`
	Draft           bool      `json:"draft"`
	Prerelease      bool      `json:"prerelease"`
	CreatedAt       time.Time `json:"created_at"`
	PublishedAt     time.Time `json:"published_at"`
	TarballURL      string    `json:"tarball_url"`
	ZipballURL      string    `json:"zipball_url"`
	Body            string    `json:"body"`
	MentionsCount   int64     `json:"mentions_count"`
}

func (s *API) ReleasesLatest(repo string) (*ReleasesLatest, error) {
	bytes, err := s.do(fmt.Sprintf("/repos/%s/releases/latest", repo))
	if err != nil {
		return nil, err
	}
	value := new(ReleasesLatest)
	if err = json.Unmarshal(bytes, value); err != nil {
		return nil, err
	}
	return value, nil
}

type Repos []Repo

type Repo struct {
	Category   Category  `json:"category"`
	Repository string    `json:"repository"`
	TagName    string    `json:"tag_name"`
	Prerelease bool      `json:"prerelease"`
	CreatedAt  time.Time `json:"created_at"`
}

type Category string

const (
	Core  Category = "core"
	Extra Category = "extra"
	Other Category = "other"
)

var (
	red     = lipgloss.NewStyle().Foreground(lipgloss.Color("#E88388"))
	green   = lipgloss.NewStyle().Foreground(lipgloss.Color("#A8CC8C"))
	yellow  = lipgloss.NewStyle().Foreground(lipgloss.Color("#DBAB79"))
	blue    = lipgloss.NewStyle().Foreground(lipgloss.Color("#71BEF2"))
	magenta = lipgloss.NewStyle().Foreground(lipgloss.Color("#D290E4"))
	cyan    = lipgloss.NewStyle().Foreground(lipgloss.Color("#66C2CD"))
	gray    = lipgloss.NewStyle().Foreground(lipgloss.Color("#B9BFCA"))
)

var version = regexp.MustCompile(`([0-9]+\.){2}[0-9]+`)

func Update() error {
	api, err := NewAPI()
	if err != nil {
		return err
	}
	repos, err := OpenRepos()
	if err != nil {
		return err
	}
	for index, repo := range repos {
		latest, err := api.ReleasesLatest(repo.Repository)
		if err != nil {
			return err
		}
		tagName := version.FindString(latest.TagName)
		if tagName != repo.TagName {
			fmt.Println(repo.Repository, green.Render(tagName), red.Render(repo.TagName))
			repos[index].TagName = tagName
			if err := SaveRepos(repos); err != nil {
				return err
			}
		} else {
			fmt.Println(repo.Repository, gray.Render(repo.TagName))
		}
	}
	return nil
}

func OpenRepos() (Repos, error) {
	env := os.Getenv("GITHUB_REPOSITORY")
	log.Println(env)

	file, err := os.Open(env)
	if err != nil {
		return nil, err
	}
	defer file.Close()
	bytes, err := io.ReadAll(file)
	var data Repos
	if err := json.Unmarshal(bytes, &data); err != nil {
		return nil, err
	}
	return data, nil
}

func SaveRepos(repos Repos) error {
	env := os.Getenv("GITHUB_REPOSITORY")
	bytes, err := json.MarshalIndent(repos, "", "   ")
	if err != nil {
		return err
	}
	if err := os.WriteFile(env, bytes, 0666); err != nil {
		return err
	}
	return nil
}
