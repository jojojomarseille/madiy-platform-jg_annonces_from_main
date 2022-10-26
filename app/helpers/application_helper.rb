module ApplicationHelper
  def category_css_class(category)
    normalized_category = ActiveSupport::Inflector.transliterate(category.name.downcase).delete("&").split(" ").compact.join("-")

    "cat-#{normalized_category}"
  end

  def short_number_to_currency(number)
    number_to_currency(number, currency: "€", format: "%n%u")
  end

  def workshop_duration(workshop)
    duration = workshop.duration
    minutes = duration.minutes > 0 ? ("%02d" % workshop.duration.minutes) : nil

    "#{duration.hours}h#{minutes}"
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
        render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields btn btn-success", id: "add_#{association}_button", data: {id: id, fields: fields.gsub("\n", ""), model: association, eventListenerFlag: "false"})
  end

  def datepicker_input form, field
    content_tag :td, :data => {:provide => 'datepicker', 'date-format' => 'yyyy-mm-dd', 'date-autoclose' => 'true'} do
      form.text_field field, class: 'form-control', placeholder: 'YYYY-MM-DD'
    end
  end

end
