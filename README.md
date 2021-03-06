#About

This is a simple scraper to dot file generator that parses MIT's Mathematics (Course 18) pages
and generates a directed graph in `math.dot` and `math.png`.  It could be used for other courses.

Example: 

[<img src='https://raw.github.com/coldnebo/mit-map/master/math.png' width='75%'/>](https://raw.github.com/coldnebo/mit-map/master/math.png)

Usage:

```bash
$ bundle install
$ ruby course.rb 
[#<MITCourse:0x00000002c3fe68
  @name="Complex Variables with Applications",
  @number="18.04",
  @prerequisites=
   ["18.02", "18.02A", "18.022", "18.023", "18.024", "18.03", "18.034"]>]
Warning: dot does not support the aspect attribute for disconnected graphs or graphs with clusters
```

Motivation: If you hear about an interesting subject, it's helpful to know the general prerequisites for it. 
This is top-down course planning instead of bottom up.  It's always helpful to ask your advisor, but this 
visualization can help you get an idea of the right questions to ask beforehand.  It gives you the big picture.


#License

This script released under the MIT license (of course):

Copyright (c) 2009 Larry Kyrala

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
