require 'erb'
require 'date'

class Template
  def initialize(summary: 'my summary', date: Date.today.to_s, assignments: [])
    @summary = summary
    @date = date
    @assignments = assignments
  end

  def skeleton
    %q{
      <%= greeting %>:

      <% if @assignments.any? %>
        Here are the homework assignments from the <%= @summary %> for <%= @date %>:

        <% @assignments.each do |assignment| %>
          * <%= assignment %>
        <% end %>
      <% else %>
        No assignments were found on the <%= summary %> for <%= @date %>.
      <% end %>

      Thanks,

      Assignments Bot
    }.gsub(/^  /, '')
  end

  def build
    ERB.new(skeleton, 0, "<>")
  end

  def output
    build.run(binding)
  end

  def to_s
    output
  end

  def greeting
    "Greetings Human"
  end
end
