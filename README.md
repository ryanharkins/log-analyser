## Usage:

#### Boring display
```
./parser.rb ./webserver.log
```

##### Result:
```
/help_page/1 23 visits
/contact 23 visits
/home 23 visits
/index 23 visits
/about/2 22 visits
/about 21 visits
----
/about/2 90 unique views
/contact 89 unique views
/index 82 unique views
/about 81 unique views
/help_page/1 80 unique views
/home 78 unique views

```

#### Table display
```
./parser.rb ./webserver.log --with-table
```

##### Result:
```

+------------------------+-----------------------+
| Path                   | Views                 |
+------------------------+-----------------------+
| /about/2               | 90                    |
| /contact               | 89                    |
| /index                 | 82                    |
| /about                 | 81                    |
| /help_page/1           | 80                    |
| /home                  | 78                    |
+------------------------+-----------------------+

+------------------------+-----------------------+
| Path                   | Unique visits         |
+------------------------+-----------------------+
| /help_page/1           | 23                    |
| /contact               | 23                    |
| /home                  | 23                    |
| /index                 | 23                    |
| /about/2               | 22                    |
| /about                 | 21                    |
+------------------------+-----------------------+

```

### Graph display
```
$ ./parser.rb ./webserver.log --with-graph
```
##### Result:
```

                              Unique visits
                ┌                                        ┐
   /help_page/1 ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 23
       /contact ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 23
          /home ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 23
         /index ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 23
       /about/2 ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 22
         /about ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 21
                └                                        ┘

                               Most views
                ┌                                        ┐
       /about/2 ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 90
       /contact ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 89
         /index ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 82
         /about ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 81
   /help_page/1 ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 80
          /home ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 78
                └                                        ┘
```

---


## Simple approach

The simplest version would be the following, very rigid and wouldn't be able to accomodate different formatted logs without modifying the whole block of code


```ruby
class SimpleLogFileParser
  def initialize(log_file_path)
    @file = File.open(log_file_path)
    @most_visits = Hash.new(0)
    @unique_visits = Hash.new { |h,k| h[k] = Set.new }
  end

  def parse
    @file.each do |line|
      page, ip_address = line.split(' ')
      @most_visits[page] += 1
      @unique_visits[page].add(ip_address)
    end
  end

  def most_views
    @most_visits.sort_by {|k, v| -v }
  end

  def unique_visits
    @unique_visits.map{|page, ips| [page, ips.length] }.sort_by { |k, v| -v}
  end
end
```
