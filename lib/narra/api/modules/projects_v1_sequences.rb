#
# Copyright (C) 2013 CAS / FAMU
#
# This file is part of Narra Core.
#
# Narra Core is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Narra Core is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Narra Core. If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Michal Mocnak <michal@marigan.net>, Krystof Pesek <krystof.pesek@gmail.com>
#

module Narra
  module API
    module Modules
      class ProjectsV1Sequences < Narra::API::Modules::Generic

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :projects do

          desc 'Return project sequences.'
          get ':name/sequences' do
            return_one_custom(Project, :name, [:admin, :author]) do |project|
              present_ok(project.sequences.limit(params[:limit]), Sequence, Narra::API::Entities::Sequence)
            end
          end

          desc 'Return project sequence.'
          get ':name/sequences/:sequence' do
            return_one_custom(Project, :name, [:admin, :author]) do |project|
              # Get item
              sequences = project.sequences.where(id: params[:sequence])
              # Check if the item is part of the project
              if sequences.empty?
                error_not_found!
              else
                present_ok(sequences.first, Sequence, Narra::API::Entities::Sequence, 'detail')
              end
            end
          end
        end
      end
    end
  end
end