module Alchemist
  class ModuleBuilder < Module
    def initialize category
      define_inspect_method(category)
      define_unit_methods(category)
    end

    def define_unit_method(names)
      names.each do |name|
        define_method(name.to_sym) { Alchemist.measure self, name.to_sym }
      end
    end

    private

    def define_inspect_method(category)
      define_method :inspect do
        "#<Module(#{category})>"
      end
    end

    def define_unit_methods(category)
      unit_names(category).map do |name|
        define_method name do
          Alchemist.measure self, name.to_sym
        end
        prefixes_for(name).map do |prefix|
          define_method "#{prefix}#{name}" do
            Alchemist.measure_prefixed self, prefix.to_sym, name.to_sym
          end
        end
      end
    end

    def library
      Alchemist.library
    end

    def unit_names(category)
      library.unit_names(category)
    end

    def prefixes_for(name)
      if library.si_units.include?(name.to_s)
        library.unit_prefixes.keys
      else
        []
      end
    end
  end
end
