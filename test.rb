require 'openssl'
require 'base64'
require 'faker'

# https://ruby-doc.org/stdlib-2.3.1/libdoc/openssl/rdoc/OpenSSL.html#module-OpenSSL-label-PKCS+-235+Password-based+Encryption
class Encrypter
  def self.encrypt(phrase, pass_phrase, salt)
    encrypter = OpenSSL::Cipher.new 'AES-128-CBC'
    encrypter.encrypt
    encrypter.pkcs5_keyivgen pass_phrase, salt

    encrypted = encrypter.update phrase
    encrypted << encrypter.final

    Base64.strict_encode64(encrypted)
  end

  def self.decrypt(encrypted, pass_phrase, salt)
    encrypted = Base64.strict_decode64(encrypted)

    decrypter = OpenSSL::Cipher.new 'AES-128-CBC'
    decrypter.decrypt
    decrypter.pkcs5_keyivgen pass_phrase, salt

    plain = decrypter.update encrypted
    plain << decrypter.final

    plain
  end
end

pass_phrase = 'my secure pass phrase goes here'
salt = '8 octets'
phrase = 'phrase'

encrypted = Encrypter.encrypt(phrase, pass_phrase, salt)
puts encrypted
# decrypted = Encrypter.decrypt(encrypted, pass_phrase, salt)
