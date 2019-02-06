class RequestLog < ApplicationRecord
  serialize :parameters, Hash
  belongs_to :widget
end
