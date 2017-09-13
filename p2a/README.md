# Project 2A: OCaml Warmup
CMSC 330, Fall 2017  
Due Friday, September 22nd, 2017

Ground Rules
------------
This is NOT a pair project. You must work on this project alone as with most other CS projects. See the Academic Integrity section for more information.

In your code, you may only use library functions found in the [`Pervasives` module][pervasives doc]. You may not use any imperative structures of OCaml such as references.

Introduction
------------
The goal of this project is to get you familiar with programming in OCaml. You will have to write a number of small functions, each of which is specified in three sections below. In our reference solution, each function's implementation is typically 3-6 lines of code, requiring no use of inner let bindings.

**This project is due in one week!** We recommend you get started right away, going from top to bottom. The problems get increasingly more challenging, and in many cases later problems can take advantage of earlier solutions.

Project Files
-------------
To begin this project, you will need to commit any uncommitted changes to your local branch and pull updates from the git repository. [Click here for directions on working with the Git repository.][git instructions] The following are the relevant files:

<!-- TODO add the real files to the document and ensure that they're correct -->
-  OCaml Files
  - **basics.ml**: This is where you will write your code for all parts of the project.
  - **basics.mli**: This file is used to describe the signature of all the functions in the module. Don't worry about this file, but make sure it exists or your code will not compile.
  - **public.ml**: This file contains all of the public test cases.
- Submission Scripts and Other Files
  - **submit.rb**: Execute this script to submit your project to the submit server.
  - **submit.jar** and **.submit**: Don't worry about these files, but make sure you have them.
  - **Makefile**: This is used to build the public tests by simply running the command `make`, just as in 216.

Notes on P2A and OCaml
----------------------
OCaml is a lot different than languages you're likely used to working with, and we'd like to point out a few quirks here that may help you work your way out of common issues with the language.
<!--TODO flesh out this section -->
- This project is additive in many ways - your solutions to earlier functions can be used to aid in writing later functions.
- Unlike most other languages, = in OCaml is the operator for structural equality whereas == is the operator for physical equality. All functions in this project (and in this class, unless ever specified otherwise) are concerned with *structural* equality.
- The subtraction operator (-) also doubles as the negative symbol for `int`s and `float`s in OCaml. As a result, the parser has trouble identifying the difference between subtraction and a negative number. When writing negative numbers, surround them in parentheses. (i.e. `some_function 5 (-10)` works, but `some_function 5 -10` will give an error)

In order to compile your project, simply run the `make` command and our `Makefile` will handle the compilation process for you, just as in 216. After compiling your code, the public tests can be run by running `public.native` (i.e. `./public.native`; think of this just like with a.out in C)

Part 1: Simple Functions
------------------------
Implement the following simple functions. No recursion is needed.

#### mult_of_y x y
- **Type**: `int -> int -> bool`
- **Description**: Returns `true` if `x` is a multiple of `y`, `false` otherwise.
- **Examples:**
```
mult_of_y 5 10 = false 
mult_of_y 0 10 = true
mult_of_y 15 0 = false
mult_of_y 10 10 = true
mult_of_y 20 10 = true
```

#### head_divisor lst
- **Type**: `int list -> bool`
- **Description**: Returns true if the second element of `lst` divides the head of `lst`, false otherwise.
- **Examples:**
```
head_divisor [] = false
head_divisor [1] = false
head_divisor [10; 5] = true
head_divisor [4; 2; 7] = true
head_divisor [9; 18] = false
```

#### second_element lst
- **Type**: `int list -> int`
- **Description**: Returns the second element of `lst`, or -1 if `lst` has less than 2 elements.
- **Examples:**
```
second_element [] = -1
second_element [1] = -1
second_element [4; 2] = 2
second_element [4; 6; 9] = 6
```

#### sum_first_three lst
- **Type**: `int list -> int`
- **Description**: Returns the sum of the first three elements of `lst`, or the sum of all elements if `lst` has less than 3 elements.
- **Examples:**
```
sum_first_three [] = 0
sum_first_three [5] = 5
sum_first_three [5; 6] = 11
sum_first_three [4; -3; 0] = 1
sum_first_three [1; 1; 1; 7] = 3
```

Part 2: Recursive List Functions
--------------------------------
The following list functions will require recursion to complete. Include the `rec` keyword in your function definition to make use of recursion or you will get an unbound value error.

#### get_val i lst
- **Type**: `int -> int list -> int`
- **Description**: Returns the element at index `i` (0-indexed) of `lst`, or -1 if `i` is not a valid index for `lst`.
- **Examples:**
```
get_val 1 [5;6;7;3] = 6 
get_val 4 [5;6;7;3] = -1
get_val (-1) [6;5;7;8] = -1
```

#### get_vals is lst
- **Type**: `int list -> int list -> int list`
- **Description**: Returns a list where the values correspond to the items found at each index of `lst` listed in `is`, or -1 for each out of bound index.
- **Examples:**
```
get_vals [2;0] [5;6;7;3] = [7;5] 
get_vals [2;4] [5;6;7;3] = [7;-1]
get_vals [] [5;6;7;3] = []
```

#### list_swap_val lst x y
- **Type**: `'a list -> 'a -> 'a -> 'a list`
- **Description**: Returns `lst` but with each instance of `x` replaced with `y` and vice versa.
- **Examples:**
```
list_swap_val ['a';'a';'b';'c';'d'] 'a' 'd' = ['d';'d';'b';'c';'a']
list_swap_val [5;6;3] 7 5 = [7;6;3]
list_swap_val [3;2;1] 8 9 = [3;2;1]
list_swap_val [] 5 7 = []
```

#### unzip lst
- **Type**: `('a * 'b) list -> 'a list * 'b list`
- **Description**: Given a list of pairs, returns a pair of lists with the elements in the same order.
- **Examples:**
```
unzip [(1,2);(3,4)] = ([1;3], [2;4])
unzip [] = ([], [])
```

#### index x lst
- **Type**: `'a -> 'a list -> int`
- **Description**: Returns the leftmost index (0-indexed) of element `x` in `lst`, or -1 if no occurrence is found.
- **Examples:**
```
index 1 [1;2] = 0 
index "bat" ["apple";"bat";"bat";"door"] = 1
index 5 [1;2;3] = -1
```

Part 3: Set Implementation using Lists
--------------------------------------

For this part of the project, you will get some real-world practice implementing one part of the OCaml standard library - sets! In practice, sets are implemented using data structures like balanced binary trees or hash tables. However, your implementation must represent sets using lists. While lists don't lend themselves to the most efficient possible implementation, they are much easier to work with.

For this project, we assume that sets are unordered, homogeneous collections of objects without duplicates. The homogeneity condition ensures that sets can be represented by OCaml lists, which are homogeneous. The only further assumptions we make about your implementation are that the empty list represents the empty set, and that it obeys the standard laws of set theory. For example, if we insert an element `x` into a set `a`, then ask whether `x` is an element of `a`, your implementation should answer affirmatively. If we take the intersection of two disjoint sets `a` and `b`, then ask whether any member of `a` or `b` is a member of the intersection, your implementation should answer negatively.

Finally, note the difference between a collection and its implementation. Although *sets* are unordered and contain no duplicates, your implementation may be ordered or contain duplicates. However, there should be no observable difference between an implementation that maintains uniqueness of elements and one that does not; or an implementation that maintains elements in sorted order and one that does not.

#### insert x a
- **Type**: `'a -> 'a list -> 'a list`
- **Description**: Inserts `x` into the set `a`.
- **Examples:**
```
insert 2 []
insert 3 (insert 2 [])
insert 3 (insert 3 (insert 2 []))
```

#### eq a b
- **Type**: `'a list -> 'a list -> bool`
- **Description**: Returns true iff `a` and `b` are equal as sets - i.e., `x` is an element of `a` iff `x` is an element of `b`.
- **Examples:**
```
eq [] (insert 2 []) = false
eq (insert 2 (insert 3 [])) (insert 3 []) = false
eq (insert 3 (insert 2 [])) (insert 2 (insert 3 [])) = true
```

#### card a
- **Type**: `'a list -> int`
- **Description**: Returns the cardinality of the set `a` - i.e., the number of elements in the set.
- **Examples:**
```
card [] = 0
card (insert 2 (insert 2 [])) = 1
card (insert 2 (insert 3 [])) = 2
```

#### elem x a
- **Type**: `'a -> 'a list -> bool`
- **Description**: Returns true iff `x`is an element of the set `a`.
- **Examples:**
```
elem 2 [] = false
elem 3 (insert 5 (insert 3 (insert 2 []))) = true
elem 4 (insert 3 (insert 2 (insert 5 []))) = false
```

#### remove x a
- **Type**: `'a -> 'a list -> 'a list`
- **Description**: Removes `x` from the set `a`.
- **Examples:**
```
card (remove 3 (insert 5 (insert 3 []))) = 1
elem 3 (remove 3 (insert 2 (insert 3 []))) = false
eq (remove 3 (insert 5 (insert 3 []))) (insert 5 []) = true
```

#### union a b
- **Type**: `'a list -> 'a list -> 'a list`
- **Description**: Returns the union of the sets `a` and `b` - i.e., `x` is an element of `union a b` iff `x` is an element of `a` or `x` is an element of `b`.
- **Examples:**
```
eq (union [] (insert 2 (insert 3 []))) (insert 3 (insert 2 [])) = true
eq (union (insert 5 (insert 2 [])) (insert 2 (insert 5 (insert 3 []))) (insert 3 (insert 2 (insert 5 []))) = true
eq (union (insert 2 (insert 7 [])) (insert 3 (insert 5 []))) (insert 5 (insert 3 (insert 7 (insert 2 [])))) = true
```

#### intersection a b
- **Type**: `'a list -> 'a list -> 'a list`
- **Description**: Returns the intersection of sets `a` and `b` - i.e., `x` is an element of `intersection a b` iff `x` is an element of `a` and `x` is an element of `b`.
- **Examples:**
```
eq (intersection (insert 3 (insert 5 (insert 2 []))) []) [] = true
eq (intersection (insert 5 (insert 7 (insert 3 (insert 2 [])))) (insert 6 (insert 4 []))) [] = true
eq (intersection (insert 3 (insert 5 (insert 2 []))) (insert 4 (insert 3 (insert 5 []))) (insert 5 (insert 3 [])) = true
```

#### subset a b
- **Type**: `'a list -> 'a list -> bool`
- **Description**: Return true iff `a` is a subset of `b` - i.e., `x` is an element of `a` implies `x` is an element of `b`.
- **Examples:**
```
subset (insert 2 (insert 4 [])) [] = false
subset (insert 5 (insert 3 [])) (insert 3 (insert 5 (insert 2 []))) = true
subset (insert 5 (insert 3 (insert 2 []))) (insert 5 (insert 3 [])) = false
```

Project Submission
------------------
<!-- TODO add filename -->
You should submit a file `basics.ml` containing your solution. You may submit other files, but they will be ignored during grading. We will run your solution as individual OUnit tests just as in the provided public test file.

Be sure to follow the project description exactly! Your solution will be graded automatically, so any deviation from the specification will result in lost points.

You can submit your project in two ways:
- Submit your `basics.ml` file directly to the [submit server][submit server] by clicking on the submit link in the column "web submission".
![Where to find the web submission link][web submit link]  
Then, use the submit dialog to submit your `basics.ml` file directly.
![Where to upload the file][web upload example]  
Select your file using the "Browse" button, then press the "Submit project!" button. You **do not** need to put it in a zip file.
- Submit directly by executing a the submission script on a computer with Java and network access. Included in this project are the submission scripts and related files listed under **Project Files**. These files should be in the directory containing your project. From there you can either execute submit.rb or run the command `java -jar submit.jar` directly (this is all submit.rb does).

No matter how you choose to submit your project, make sure that your submission is received by checking the [submit server][submit server] after submitting.

Academic Integrity
------------------
Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.

<!-- Link References -->


<!-- These should always be left alone or at least updated -->
[pervasives doc]: https://caml.inria.fr/pub/docs/manual-ocaml/libref/Pervasives.html
[git instructions]: ../git_cheatsheet.md
[submit server]: submit.cs.umd.edu
[web submit link]: ../common-images/web_submit.jpg
[web upload example]: ../common-images/web_upload.jpg
