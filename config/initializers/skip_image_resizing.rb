if Rails.env.test?
  CarrierWave.configure do |c|
    c.enable_processing = false
  end
end