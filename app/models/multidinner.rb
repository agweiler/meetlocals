class Multidinner < ActiveRecord::Base
	belongs_to :partner

	def assign_hosts_to_group_size
		 self.group_sizes.zip(self.hosts_chosen)
	end
end
