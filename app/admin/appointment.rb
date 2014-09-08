ActiveAdmin.register Appointment do

  filter :manager
  filter :title
  filter :description
  filter :date
  filter :time
  filter :assigned_pin
  filter :status

  index :as => ActiveAdmin::Views::IndexAsTable do
    column :id do |appointment|
      link_to appointment.id, admin_appointment_path(appointment)
    end
    column :manager do |appointment|
      link_to appointment.manager, admin_manager_path(appointment.manager)
    end
    column :title
    column :description
    column :date
    column :time
    column :status
    column :assigned_pin
    column :consumer do |appointment|
      if (appointment.consumer)
        link_to appointment.consumer, admin_consumer_path(appointment.consumer) 
      else 
        link_to "Assign"
      end    
    end
    default_actions
  end

  form do |f|
    f.inputs "Appointment" do
      f.input :manager, :as => :select
      f.input :title
      f.input :description
      f.input :date, :as => :date_select
      f.input :time, :as => :time_select
      f.input :assigned_pin
      f.input :status
    end

    f.buttons
  end

end

