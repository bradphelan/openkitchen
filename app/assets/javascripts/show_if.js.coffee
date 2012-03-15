#
# This mini module allows you to write form where element can be shown
# hidden depending on a condition from another element. Works well
# with formtastic. For example
#
# = f.inputs do
#   = f.input :public
#   = f.input :public_seats, 
#     :input_html => { 'data-show-if' => "input:[name='event[public]']:checkbox", 
#       'data-condition' => ':checked', 
#       'data-parent' => 'fieldset' }
#
# Data Attributes
#sd§
#   data-show-if: selector for matching the element to monitor for change
#   data-condition: selector to append to data-show-if to generate boolean condition
#   data-parent: selector to search upwards from element for hiding purposes
#
$(document).ready =>

    $("[data-show-if]").each (index, element)=>

      element = $(element)

      form = element.closest("form")

      # Find the trigger element
      trigger_element = form.find(element.attr('data-show-if'))

      # The parent selector for hiding
      parent_element = element.closest(element.attr('data-parent'))

      # The selector condition to append to trigger_element
      trigger_element_condition = element.attr('data-condition')
      condition = "#{element.attr('data-show-if')}#{trigger_element_condition}"

      control = do(trigger_element, condition, parent_element, form)->
        -> parent_element.toggle(form.find(condition).length > 0)

      trigger_element.on "change", =>
        control()

      control()



