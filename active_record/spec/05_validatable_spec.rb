require 'active_record_base'

describe 'Validatable' do 
  describe '#validates presence' do
    before(:each) do
      class Cat < ActiveRecordBase
        self.finalize!
      end
    end

    it "should validate the presence of the name" do
      class Cat
        validates(:name, { presence: true })
      end

      c = Cat.new
      expect(Cat.valid?(c)).to eq(false)
    end

    context "should validate the length of the name" do
      it "should check the max" do
        class Cat
          validates(:name, length: { max: 10 })
        end

        c = Cat.new(name: "POTENTIALLYTHELONGESTNAMEFORACAT")
        expect(Cat.valid?(c)).to eq(false)
      end

      it "should check the min" do
        class Cat
          validates(:name, length: { max: 500 })
        end

        c = Cat.new(name: "POTENTIALLYTHELONGESTNAMEFORACAT")
        expect(Cat.valid?(c)).to eq(false)
      end

      it "should check for uniqueness" do
        class Cat
          validates(:name, uniqueness: true)
        end

        c = Cat.new(name: "Breakfast")
        expect(Cat.valid?(c)).to eq(false)
      end

      it "should check multiple options" do
        class Cat
          validates(
            :name,
            {
              presence: true,
              length: {in: 5..7},
              uniqueness: true
            }
          )
        end
        c = Cat.new(name: "sixlet")
        b = Cat.new(name: "Breakfast")
        d = Cat.new(name: "fivel")
        expect(Cat.valid?(c)).to eq(true)
        expect(Cat.valid?(b)).to eq(false)
        expect(Cat.valid?(d)).to eq(false)
      end
    end

    it "should automatically run on save" do
      class Cat
        validates(:name, presence: true)
      end

      c = Cat.new
      expect(c.save).to eq(false)
    end 
  end
end