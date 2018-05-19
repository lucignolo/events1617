#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
# encoding: utf-8
Product.delete_all
Product.create!(title: 'CoffeeScript',
  description:
    %{<p>
        CoffeeScript is JavaScript done right. It provides all of JavaScript's
	functionality wrapped in a cleaner, more succinct syntax. In the first
	book on this exciting new language, CoffeeScript guru Trevor Burnham
	shows you how to hold onto all the power and flexibility of JavaScript
	while writing clearer, cleaner, and safer code.
      </p>},
  image_url:   'cs.jpg',
  price: 36.00)
# . . .
Product.create!(title: 'Programming Ruby 1.9 & 2.0',
  description:
    %{<p>
        Ruby is the fastest growing and most exciting dynamic language
        out there. If you need to get working programs delivered fast,
        you should add Ruby to your toolbox.
      </p>},
  image_url: 'ruby.jpg',
  price: 49.95)
# . . .
Product.create!(title: 'Rails Test Prescriptions',
  description:
    %{<p>
        <em>Rails Test Prescriptions</em> is a comprehensive guide to testing
        Rails applications, covering Test-Driven Development from both a
        theoretical perspective (why to test) and from a practical perspective
        (how to test effectively). It covers the core Rails testing tools and
        procedures for Rails 2 and Rails 3, and introduces popular add-ons,
        including Cucumber, Shoulda, Machinist, Mocha, and Rcov.
      </p>},
  image_url: 'rtp.jpg',
  price: 34.95)
#. . . . .
# prova per inserire qualche record Publisher in tabella publishers
#commento tutto per potere ritornare all'uso di development.sqlite3 originario 1 maggio 18
#Publisher.delete_all
#Publisher.create!(nome: 'Prova nome primo editor di prova in Publishers',
#  vecchioid: 987)
# . . .
#Publisher.create!(nome: 'Campo nome per secondo editore di prova in Publishers',
#  vecchioid: 986)
#. . . . .
# prova con output di ugoRUNExportTable1.rb (a video)
#Publisher.delete_all!
Publisher.create!(nome: %{Athesia},
vecchioid: 1 )
# . . .
Publisher.create!(nome: %{CDA},
vecchioid: 2 )
# . . .
Publisher.create!(nome: %{Cierre},
vecchioid: 3 )
# . . .
Publisher.create!(nome: %{Costa Editore},
vecchioid: 4 )
# . . .
Publisher.create!(nome: %{De Agostini},
vecchioid: 5 )
# . . .
Publisher.create!(nome: %{EDT (Rodriguez)},
vecchioid: 6 )
# . . .
Publisher.create!(nome: %{Fodor's},
vecchioid: 7 )
# . . .
Publisher.create!(nome: %{Frassinelli},
vecchioid: 8 )
# . . .
Publisher.create!(nome: %{Iter},
vecchioid: 9 )
# . . .
Publisher.create!(nome: %{Kompass-Euroservizi},
vecchioid: 10 )
# . . .
Publisher.create!(nome: %{Lonely Planet},
vecchioid: 11 )
# . . .
Publisher.create!(nome: %{Moizzi},
vecchioid: 12 )
# . . .
Publisher.create!(nome: %{Mondadori},
vecchioid: 13 )
# . . .
Publisher.create!(nome: %{Mursia},
vecchioid: 14 )
# . . .
Publisher.create!(nome: %{Nelles},
vecchioid: 15 )
# . . .
Publisher.create!(nome: %{Panorama},
vecchioid: 16 )
# . . .
Publisher.create!(nome: %{Priuli Verlucca},
vecchioid: 17 )
# . . .
Publisher.create!(nome: %{Rough guide},
vecchioid: 18 )
# . . .
Publisher.create!(nome: %{Rubbettino},
vecchioid: 19 )
# . . .
Publisher.create!(nome: %{Studio F.M.B. Bologna},
vecchioid: 20 )
# . . .
