require 'securerandom'

secret_key = SecureRandom.hex(32) # Puedes ajustar el tamaño
ENV['APP_SECRET_KEY'] = secret_key
