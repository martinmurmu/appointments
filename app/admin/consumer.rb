ActiveAdmin.register Consumer do
  menu :priority => 4

  filter :phone_number

  show :title => :phone_number do
    # Customizations...
    attributes_table do
      row :id
      row :phone_number
      row 'Managers' do |consumer|
        link_to consumer.managers.count, admin_managers_path('q[consumers_id_eq]' => consumer)
      end
      row 'Appointments' do |consumer|
        link_to consumer.appointments.count, admin_appointments_path('q[consumer_id_eq]' => consumer)
        # Query example
        # q[manager_id_eq]=2
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments # Add this line for comment block
  end
end
