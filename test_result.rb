# frozen_string_literal: true

require 'json'
require 'byebug'
require 'date'
require 'ostruct'

def week
  first_day = DateTime.parse('2022-08-01 00:00:00')
  last_day = DateTime.parse('2022-08-05 00:00:00')

  first_day.step(last_day, (1.0 / 24)).to_a.reject do |d|
    d.hour < 9 || d.hour > 18
  end
end

def sandra_busy_slots
  sandra_input = JSON.parse(File.read('input_sandra.json'))

  sandra_input.map do |d|
    OpenStruct.new(name: 'Sandra', start: DateTime.parse(d['start']), end: DateTime.parse(d['end']))
  end
end

def andy_busy_slots
  andy_input = JSON.parse(File.read('input_andy.json'))

  andy_input.map do |d|
    OpenStruct.new(name: 'Andy', start: DateTime.parse(d['start']), end: DateTime.parse(d['end']))
  end
end

def result_json_format(array)
  array.map { |value| { start: value[0].to_s, end: value[1].to_s } }
end

def available_times
  busy_slots = sandra_busy_slots + andy_busy_slots
  free_times = []

  busy_slots.each do |slot|
    week.each do |day|
      free_times << day unless (slot.start...slot.end).cover?(day)
    end
  end

  result_json_format(free_times.each_slice(2).to_a)
end

File.open('available_time.json', 'w') { |file| file.write(JSON.pretty_generate(available_times)) }
