# Wikidata as a unifying resource for data on collectors of botanical and zoological specimens

Notes on STSM-Mobilise project.

## Objectives

The main objectives of this STSM are:
- Find the total number of biological specimen collectors in Wikidata. Ideally, this would be done through SPARQL queries which can be replicated afterwards as Wikidata is in constant flux.
- Assess the comprehensiveness of data on these collectors, using both shape expressions and more in depth analysis in R for specific properties of interest.
- Describe regional and temporal patterns for these collectors, as well as gender balance and the extent of external links.
- Data validation by matching through external sources such as Bloodhound.

 

## Useful links

[Bloodhound](https://bloodhound-tracker.net)
[Weighted cliques](https://linen-baseball.glitch.me)
[Cyclopaedia of Malesian Collectors](http://www.nationaalherbarium.nl/FMCollectors/home.htm) (see also [github copy](https://github.com/rdmpage/cyclopaedia-malesian-collectors)
[Shape Expressions Language 2.1](http://shex.io/shex-semantics/)

[Wikidata search for Ernst Cleveland Abbe](https://www.wikidata.org/w/api.php?action=wbsearchentities&search=Ernst%20Cleveland%20Abbe&type=item&format=json&language=en)

## Reading

Penn, M. G., Cafferty, S., & Carine, M. (2017). Mapping the history of botanical collectors: spatial patterns, diversity, and uniqueness through time. Systematics and Biodiversity, 16(1), 1–13. doi:[10.1080/14772000.2017.1355854](https://doi.org/10.1080/14772000.2017.1355854)



## Random thoughts

We can frame question as being “given this name string, what person does it correspond too?” This means we take a name and try and match it to names in  trusted source, e.g. Wikidata.

But if problem is really “I have this name string on a label, who is it?” then we potentially have other information, such as taxon, date, and location. Imagine that we have an authoritative database of who studied what species and when (e.g., IPNI for plants), then we could generate “all” possible labels that could be generated from that data, such as (person name, species, date), and then we match observed label data to that dataset. The best match is likely to be a good candidate for being the actual person.

Could you take this approach to Wikidata itself? Say you construct SPARQL queries based on the other information you have. Then you process the results based on similarity of their item label to the person name text string provided. As long as the person is in wikidata, the other information provided is also set in Wikidata and a query can be made sufficiently comprehensive to cover all people who collected specimens, this should work?

Then we could set the scope of this STSM: 

- how good is wikidata's coverage of specimen collectors?
- how comprehensive is wikidata's information on those people (probably focus on a few key properties)?
- (how) are specimen-collecting people consistently modeled in wikidata?
- demo of this approach?
