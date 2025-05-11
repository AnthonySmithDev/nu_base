
export-env {
  $env.SHALON_ORDEN = "29928384"
  $env.SHALON_CODIGO = "99DD"
}

export def buscar [] {
  let args = [
    -H 'Accept: */*'
    -H 'Accept-Language: en-US,en;q=0.7'
    -H 'Connection: keep-alive'
    -H 'Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryqPeDjCPx2wt1xo19'
    -H 'Origin: https://rastrea.shalom.pe'
    -H 'Referer: https://rastrea.shalom.pe/'
    -H 'Sec-Fetch-Dest: empty'
    -H 'Sec-Fetch-Mode: cors'
    -H 'Sec-Fetch-Site: cross-site'
    -H 'Sec-GPC: 1'
    -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
    -H 'sec-ch-ua: "Not)A;Brand";v="99", "Brave";v="127", "Chromium";v="127"'
    -H 'sec-ch-ua-mobile: ?0'
    -H 'sec-ch-ua-platform: "Linux"'
    --data-raw $'------WebKitFormBoundaryqPeDjCPx2wt1xo19\r\nContent-Disposition: form-data; name="numero"\r\n\r\n($env.SHALON_ORDEN)\r\n------WebKitFormBoundaryqPeDjCPx2wt1xo19\r\nContent-Disposition: form-data; name="codigo"\r\n\r\n($env.SHALON_CODIGO)\r\n------WebKitFormBoundaryqPeDjCPx2wt1xo19\r\nContent-Disposition: form-data; name="ose_id"\r\n\r\n\r\n------WebKitFormBoundaryqPeDjCPx2wt1xo19--\r\n'
  ]
  curl 'https://servicesweb.shalomcontrol.com/api/v1/web/rastrea/buscar' ...$args
}

export def entregado [] {
  buscar | get entregado?
}

export def estados [] {
  let args = [
    -H 'Accept: */*'
    -H 'Accept-Language: en-US,en;q=0.7'
    -H 'Connection: keep-alive'
    -H 'Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryelvJqqyyDLK0uYVa'
    -H 'Origin: https://rastrea.shalom.pe'
    -H 'Referer: https://rastrea.shalom.pe/'
    -H 'Sec-Fetch-Dest: empty'
    -H 'Sec-Fetch-Mode: cors'
    -H 'Sec-Fetch-Site: cross-site'
    -H 'Sec-GPC: 1'
    -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
    -H 'sec-ch-ua: "Not)A;Brand";v="99", "Brave";v="127", "Chromium";v="127"'
    -H 'sec-ch-ua-mobile: ?0'
    -H 'sec-ch-ua-platform: "Linux"'
    --data-raw $'------WebKitFormBoundaryelvJqqyyDLK0uYVa\r\nContent-Disposition: form-data; name="ose_id"\r\n\r\n33409875\r\n------WebKitFormBoundaryelvJqqyyDLK0uYVa--\r\n'
  ]
  curl 'https://servicesweb.shalomcontrol.com/api/v1/web/rastrea/estados' ...$args
}
