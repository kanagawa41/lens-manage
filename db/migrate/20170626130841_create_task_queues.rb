class CreateTaskQueues < ActiveRecord::Migration[5.1]
  def change
    create_table :task_queues do |t|
      t.time :regist_time
      t.time :late_time
      t.boolean :complete_flag

      t.timestamps
    end

    add_reference :task_queues, :reserve, foreign_key: true
  end
end
