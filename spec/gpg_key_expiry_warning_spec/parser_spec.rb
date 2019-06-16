require "gpg_key_expiry_warning"

RSpec.describe GPGKeyExpiryWarning::Parser do
  describe "::parse_keys/1" do
    it "parses key" do
      data = "tru::1:1559213084:1609745466:3:1:5\n"
      data << "pub:u:2048:1:A8D0FF51860E2615:1514408689:1609745466::u:::scESCA::::::23:1559578929:1 https\\x3a//[2001\\x3a41d0\\x3a800\\x3ad1e\\x3a\\x3a82\\x3a0]\\x3a443:\n"
      data << "fpr:::::::::78AB56E016E71D04579B7A72A8D0FF51860E2615:\n"
      data << "uid:u::::1546673466::9BCDD327460E3D927D3B9A4FDC9B04A84799605E::Daniel Schömer <daniel.schoemer@gmx.net>:::::::::1514409170:5:\n"
      data << "sub:u:2048:1:A243284A6DC82699:1514408713:1578209484:::::s::::::23:\n"
      data << "fpr:::::::::68E3EC7D5DAC8221C53A49F5A243284A6DC82699:\n"
      data << "sub:u:2048:1:4846DE89DFF5A2F1:1514408728:1578209484:::::e::::::23:\n"
      data << "fpr:::::::::30A68F7CE48D83E357BDB8734846DE89DFF5A2F1:\n"
      data << "sub:u:2048:1:133007E82005F2A2:1514408741:1578209484:::::a::::::23:\n"
      data << "fpr:::::::::B7E2D65661CE3CF0E39BAF68133007E82005F2A2:\n"

      expected = [{
        uids: [{name: "Daniel Schömer <daniel.schoemer@gmx.net>", trust: :ultimate}],
        fingerprint: "78AB56E016E71D04579B7A72A8D0FF51860E2615",
        length: "2048",
        algorithm: "1",
        created: "1514408689",
        expires: "1609745466",
        capabilities: "scESCA",
        subkeys: [
          {
            fingerprint: "68E3EC7D5DAC8221C53A49F5A243284A6DC82699",
            length: "2048",
            algorithm: "1",
            created: "1514408713",
            expires: "1578209484",
            capabilities: "s",
          },
          {
            fingerprint: "30A68F7CE48D83E357BDB8734846DE89DFF5A2F1",
            length: "2048",
            algorithm: "1",
            created: "1514408728",
            expires: "1578209484",
            capabilities: "e",
          },
          {
            fingerprint: "B7E2D65661CE3CF0E39BAF68133007E82005F2A2",
            length: "2048",
            algorithm: "1",
            created: "1514408741",
            expires: "1578209484",
            capabilities: "a",
          },
        ],
      }]

      parsed = GPGKeyExpiryWarning::Parser.parse_keys(data)
      expect(parsed).to eq(expected)
    end
  end
end
