class LazyWorkQueue < GirlFriday::WorkQueue

  include Singleton

  def self.define *options, &block
    Class.new LazyWorkQueue do
      define_method :initialize do
        super *options do |info|
          block.call info
        end
      end
    end
  end

  def self.push *args
    instance.push *args
  end

  def self.status
    instance.status
  end

end
