# Wikidata as a unifying resource for data on collectors of botanical and zoological specimens

Notes on STSM-Mobilise project.
 

## Useful links

[Bloodhound](https://bloodhound-tracker.net)
[Weighted cliques](https://linen-baseball.glitch.me)
[Cyclopaedia of Malesian Collectors](http://www.nationaalherbarium.nl/FMCollectors/home.htm) (see also [github copy](https://github.com/rdmpage/cyclopaedia-malesian-collectors)
[Shape Expressions Language 2.1](http://shex.io/shex-semantics/)


## Random thoughts

We can frame question as being “given this name string, what person does it correspond too?” This means we take a name and try and match it to names in  trusted source, e.g. Wikidata.

But if problem is really “I have this name string on a label, who is it?” then we potentially have other information, such as taxon, date, and location. Imagine that we have an authoritative database of who studied what species and when (e.g., IPNI for plants), then we could generate “all” possible labels that could be generated from that data, such as (person name, species, date), and then we match observed label data to that dataset. The best match is likely to be a good candidate for being the actual person. 
