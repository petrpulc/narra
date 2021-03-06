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
      class SettingsV1 < Narra::API::Modules::Generic

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :settings do

          desc "Return settings."
          get do
            auth! [:admin]
            present_ok_generic(:settings, Narra::Tools::Settings.all)
          end

          desc "Return defaults."
          get 'defaults' do
            auth!
            present_ok_generic(:defaults, Narra::Tools::Settings.defaults)
          end

          desc "Return a specific setting."
          get ':name' do
            auth!
            # get settings
            setting = Narra::Tools::Settings.get(params[:name])
            # present
            if (setting.nil?)
              error_not_found
            else
              present_ok_generic(:setting, present({name: params[:name], value: setting}))
            end
          end

          desc "Update a specific setting."
          post ':name/update' do
            auth! [:admin]
            required_attributes! [:value]
            # update
            Narra::Tools::Settings.set(params[:name], params[:value])
            # present
            present_ok
          end
        end
      end
    end
  end
end