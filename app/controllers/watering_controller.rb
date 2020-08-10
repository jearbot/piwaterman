class WateringController < ApplicationController
  require 'rpi_gpio'

  PIN_1 = 2
  PIN_2 = 3
  PIN_3 = 4

  attr_accessor :pin1, :pin2, :control

  before_action :set_pins
  after_action :clean_up

  def water(duration)
    on
    sleep(duration)
    off
  end

  def off
    pin1.set_low PIN_1
    pin2.set_low PIN_2

    sleep(1)

    control.set_low PIN_3

    sleep(0.5)

    control.set_high PIN_3

    sleep(0.5)
  end

  def on
    control.set_low PIN_3

    sleep(0.5)

    control.set_high PIN_3

    sleep(0.5)
  end

  private

  def clean_up
    RPi::GPIO.clean_up PIN_1
    RPi::GPIO.clean_up PIN_2
    RPi::GPIO.clean_up PIN_3
  end

  def set_pins
    RPi::GPIO.set_numbering :bcm
    RPi::GPIO.set_warnings(false)
  end

  def pin1
    @pin1 ||= RPi::GPIO.setup PIN_1, :as => :output
  end

  def pin2
    @pin2 ||= RPi::GPIO.setup PIN_2, :as => :output
  end

  def control
    @control ||= RPi::GPIO.setup PIN_3, :as => :output
  end
end
