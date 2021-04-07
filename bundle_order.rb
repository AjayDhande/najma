class BundleOrder
  attr_accessor :items, :image, :audio, :video, :items_group, :resultant_bundle

  def initialize(items)
    @items = items
    @image = Hash[5 => 450, 10 => 800]
    @audio = Hash[3 => 427.50, 6 => 810, 9 => 1147.50]
    @video = Hash[3 => 570, 5 => 900, 9 => 1530]
    item_arr = @items.split(' ')
    if ((item_arr.length == 2) && (((/\A\d+\z/.match(item_arr[0])) && (item_arr[1].upcase == "IMG")) || ((/\A\d+\z/.match(item_arr[0])) && (item_arr[1].upcase == "FLAC")) || ((/\A\d+\z/.match(item_arr[0])) && (item_arr[1].upcase == "VID")))) 
      @items_group = Hash[ [item_arr[1].upcase].zip(@items.split(/\s+/,2) -[item_arr[1]])]
    elsif ((item_arr.length == 4) && (((/\A\d+\z/.match(item_arr[0])) && (item_arr[1].upcase == "IMG") && (/\A\d+\z/.match(item_arr[2])) && (item_arr[3].upcase == "FLAC")) || ((/\A\d+\z/.match(item_arr[0])) && (item_arr[1].upcase == "IMG") && (/\A\d+\z/.match(item_arr[2])) && (item_arr[3].upcase == "VID")) || ((/\A\d+\z/.match(item_arr[0])) && (item_arr[1].upcase == "FLAC") && (/\A\d+\z/.match(item_arr[2])) && (item_arr[3].upcase == "IMG")) || ((/\A\d+\z/.match(item_arr[0])) && (item_arr[1].upcase == "FLAC") && (/\A\d+\z/.match(item_arr[2])) && (item_arr[3].upcase == "VID")) || ((/\A\d+\z/.match(item_arr[0])) && (item_arr[1].upcase == "VID") && (/\A\d+\z/.match(item_arr[2])) && (item_arr[3].upcase == "IMG")) || ((/\A\d+\z/.match(item_arr[0])) && (item_arr[1].upcase == "VID") && (/\A\d+\z/.match(item_arr[2])) && (item_arr[3].upcase == "FLAC"))))
      @items_group = Hash[ [item_arr[1].upcase, item_arr[3].upcase].zip(@items.split(/\s+/,4) -[(item_arr[1]), (item_arr[3])])]
    elsif ((item_arr.length == 6) && (/\A\d+\z/.match(item_arr[0])) && (item_arr[1].upcase == "IMG") && (/\A\d+\z/.match(item_arr[2])) && (item_arr[3].upcase == "FLAC") && (/\A\d+\z/.match(item_arr[4])) && (item_arr[5].upcase == "VID"))
      @items_group = Hash[ [(item_arr[1].upcase), (item_arr[3].upcase), (item_arr[5].upcase)].zip(@items.split(/\s+/,6) -[(item_arr[1]), (item_arr[3]), (item_arr[5])])]
    end
    @items_group = @items_group.compact if @items_group
    @resultant_bundle = []
  end

  def calculate_bundle
    if @items_group
      @items_group.each do |g|
        g[0] == 'IMG' ? get_resultant_format('IMG', g,  @image) : g[0] == 'FLAC' ? get_resultant_format('FLAC', g,  @audio) : get_resultant_format('VID', g, @video)
      end
      puts !@resultant_bundle.empty? ? @resultant_bundle : "Not Available. Please enter different number of items."
    else
      puts "Please enter number of items as per mentioned format. Example: 10 IMG 15 FLAC 13 VID"
    end
  end

  def get_resultant_format(type, item, submission_arr)
    resultant = []
    submission_arr.each do |format|
      if submission_arr.keys.any? {|k| k.to_i == item[1].to_i}
        if format[0].to_i == item[1].to_i
          resultant.push("#{item[1]}" + " #{type} " + "$#{sprintf('%.2f', format[1])}" + " : {1 x " + "#{item[1]}" + " $" + "#{sprintf('%.2f', format[1])}" + "}")
          break
        end
        next
      else
        !!submission_arr.keys.sort.reverse.uniq.combination(2).each do |a, b| 
          (1..item[1].to_i).each do |n|
            if ((n*a.to_i) + b.to_i) == item[1].to_i
              calc_tot = (n*submission_arr[a].to_f) + submission_arr[b].to_f
              resultant.push("#{item[1]}" + " #{type} " + "$#{sprintf('%.2f', calc_tot.round(2))}" + " : {" + "#{n}" + " x " + "#{a.to_i}" + " $" + "#{sprintf('%.2f', n*submission_arr[a].to_f.round(2))}" + "}"+ " , {1 x " + "#{b.to_i}" + " $" + "#{sprintf('%.2f', submission_arr[b])}" + "}")
              break 
            elsif (a.to_i + (n*b.to_i)) == item[1].to_i
              calc_tot =  submission_arr[a].to_f + (n*submission_arr[b].to_f)
              resultant.push("#{item[1]}" + " #{type} " + "$#{sprintf('%.2f', calc_tot.round(2))}" + " : {1 x " + "#{a.to_i}" + " $" + "#{sprintf('%.2f', submission_arr[a])}" + "}"+ " , {" + "#{n}" + " x " + "#{b.to_i}" + " $" + "#{sprintf('%.2f', n*submission_arr[b].to_f.round(2))}" + "}")
              break
            end
          end
          break unless resultant.empty?
        end
        if (item[1].to_i % format[0].to_i == 0) && resultant.empty?
          resultant.push("#{item[1]}" + " #{type} " + "$#{sprintf('%.2f', ((item[1].to_i)/(format[0].to_i))*format[1])}" + " : {" + "#{(item[1].to_i)/(format[0].to_i)}" + " x " + "#{format[0]}" + " $" + "#{sprintf('%.2f', ((item[1].to_i)/(format[0].to_i))*format[1])}" + "}")
          break
        end
        break unless resultant.empty?
      end 
    end
    @resultant_bundle.push(resultant) unless resultant.empty?
  end
end

puts "Enter the number of items followed by submission format code. Example: 10 IMG 15 FLAC 13 VID"
items = gets.chomp
bundle = BundleOrder.new(items)
bundle.calculate_bundle

