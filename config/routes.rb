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

require 'sidekiq/web'

Narra::Application.routes.draw do

  constraints(Narra::Constraints::AdminConstraint) do
    namespace 'service' do
      # sidekiq monitoring
      mount Sidekiq::Web => '/workers'
    end
  end

  # Mount the API root mounter
  mount Narra::API::Mounter => '/'

  # Root redirection
  root :to => redirect('/v1/system/version')
end

