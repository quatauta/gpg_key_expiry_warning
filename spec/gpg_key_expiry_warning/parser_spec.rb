require "gpg_key_expiry_warning"

RSpec.describe GPGKeyExpiryWarning::Parser do
  let(:key_data) {
    <<~KEY_DATA
      tru::1:1559213084:1609745466:3:1:5.rspec
      pub:u:2048:1:A8D0FF51860E2615:1514408689:1609745466::u:::scESCA::::::23:1559578929:1 https\\x3a//[2001\\x3a41d0\\x3a800\\x3ad1e\\x3a\\x3a82\\x3a0]\\x3a443:
      fpr:::::::::78AB56E016E71D04579B7A72A8D0FF51860E2615:
      uid:u::::1546673466::9BCDD327460E3D927D3B9A4FDC9B04A84799605E::Daniel Schömer <daniel.schoemer@gmx.net>:::::::::1514409170:5:
      sub:u:2048:1:A243284A6DC82699:1514408713:1578209484:::::s::::::23:
      fpr:::::::::68E3EC7D5DAC8221C53A49F5A243284A6DC82699:
      sub:u:2048:1:4846DE89DFF5A2F1:1514408728:1578209484:::::e::::::23:
      fpr:::::::::30A68F7CE48D83E357BDB8734846DE89DFF5A2F1:
      sub:u:2048:1:133007E82005F2A2:1514408741:1578209484:::::a::::::23:
      fpr:::::::::B7E2D65661CE3CF0E39BAF68133007E82005F2A2:
    KEY_DATA
  }
  let(:key_parsed) {
    [{type: :pub,
      algorithm: :rsa,
      capabilities: [:sign, :cert],
      created: Time.at(1514408689),
      expires: Time.at(1609745466),
      fingerprint: "78AB56E016E71D04579B7A72A8D0FF51860E2615",
      id: "A8D0FF51860E2615",
      length: 2048,
      ownertrust: :u,
      updated: Time.at(1559578929),
      validity: :u,
      uids: [{created: Time.at(1546673466),
              type: :uid,
              updated: Time.at(1514409170),
              user_id: "Daniel Schömer <daniel.schoemer@gmx.net>",
              validity: :u,}],
      subkeys: [{type: :sub,
                 algorithm: :rsa,
                 capabilities: [:sign],
                 created: Time.at(1514408713),
                 expires: Time.at(1578209484),
                 fingerprint: "68E3EC7D5DAC8221C53A49F5A243284A6DC82699",
                 id: "A243284A6DC82699",
                 length: 2048,
                 validity: :u,},
                {type: :sub,
                 algorithm: :rsa,
                 capabilities: [:encrypt],
                 created: Time.at(1514408728),
                 expires: Time.at(1578209484),
                 fingerprint: "30A68F7CE48D83E357BDB8734846DE89DFF5A2F1",
                 id: "4846DE89DFF5A2F1",
                 length: 2048,
                 validity: :u,},
                {type: :sub,
                 algorithm: :rsa,
                 capabilities: [:auth],
                 created: Time.at(1514408741),
                 expires: Time.at(1578209484),
                 fingerprint: "B7E2D65661CE3CF0E39BAF68133007E82005F2A2",
                 id: "133007E82005F2A2",
                 length: 2048,
                 validity: :u,},],}]
  }

  describe "::parse_keys/1" do
    it "parses key" do
      parsed = GPGKeyExpiryWarning::Parser.parse_keys(key_data)
      expect(parsed).to eq(key_parsed)
    end
  end
end
