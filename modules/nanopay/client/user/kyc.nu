
def host [...path: string] {
  '/kyc' | append $path | path join
}

export def view [] {
  https get (host) | get data
}

export def create [] {
  https post (host) {} | get data
}

export def create_doc [] {
  let number = (random int 79000000..89000000 | into string)
  let body = {
    country_id: 100,
    date_exp: '23/03/2031',
    document_type_id: 1,
    document_number: $number,
    back_img: (random uuid),
    front_img: (random uuid),
    selfie_img: (random uuid)
  }
  https post (host personal doc) $body | get data
}

export def create_info [
  first?: string
  middle?: string
  last?: string
] {
  let first = ($first | default -e (faker name first))
  let middle = ($middle | default -e (faker name first))
  let last = ($last | default -e (faker name last))
  let body = {
    country_id: 100,
    city: (faker country city),
    address: (faker country address),
    postal_code: (faker country code)
    date_of_birth: '23/03/2001',
    first_name: $first,
    middle_name: $middle,
    last_name: $last,
  }
  https post (host personal info) $body | get data
}

def sql-verify [] {
  sql query -n "UPDATE know_your_customer SET status = 1"
}

def mongo-verify [] {
  use mongo.nu
  mongo coll updateMany kyc {} { status: 1 }
}

export def verify [] {
  mongo-verify
}
