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

###  Wikidata API queries

Entity search looks for Wikidata items, tends to find things whose title exactly matches the search term.

[Wikidata entity search for Ernst Cleveland Abbe](https://www.wikidata.org/w/api.php?action=wbsearchentities&search=Ernst%20Cleveland%20Abbe&type=item&format=json&language=en)

srsearch can find approximate matches, but title returned is Wikidata item, not item title. Use ```titlesnippet|snippet``` to get the title (plus search highlighting).

[Wikidata search for Edward Balls](https://www.wikidata.org/w/api.php?action=query&list=search&srsearch=Edward+Balls&srprop=titlesnippet%7Csnippet&format=json)
```
{
	"batchcomplete": "",
	"query": {
		"searchinfo": {
			"totalhits": 3
		},
		"search": [{
			"ns": 0,
			"title": "Q260464",
			"pageid": 252675,
			"snippet": "British politician",
			"titlesnippet": "Ed <span class=\"searchmatch\">Balls</span>"
		}, {
			"ns": 0,
			"title": "Q21505603",
			"pageid": 23550326,
			"snippet": "botanist (1892-1984)",
			"titlesnippet": "<span class=\"searchmatch\">Edward</span> Kent <span class=\"searchmatch\">Balls</span>"
		}, {
			"ns": 0,
			"title": "Q56920165",
			"pageid": 56837127,
			"snippet": "",
			"titlesnippet": "The moral status of animals and the Animals (Scientific Procedures) Act 1986"
		}]
	}
}
```



[Other method of wikipedia search, for Ed Balls - seems to be quite slower](https://www.wikidata.org/w/api.php?action=query&list=search&srsearch=Edward+Balls&srprop=titlesnippet%7Csnippet&format=json)

## Other APIs

- [ZooBank](http://zoobank.org/Api)
- [BHL](https://about.biodiversitylibrary.org/tools-and-services/developer-and-data-tools/#APIs) Note that you need a developer key
- [IPNI (beta)](https://beta.ipni.org/api/1/a/urn:lsid:ipni.org:authors:20009115-1)


## Reading

Penn, M. G., Cafferty, S., & Carine, M. (2017). Mapping the history of botanical collectors: spatial patterns, diversity, and uniqueness through time. Systematics and Biodiversity, 16(1), 1–13. doi:[10.1080/14772000.2017.1355854](https://doi.org/10.1080/14772000.2017.1355854)

Funk, V. A., & Mori, S. A. (1989). A bibliography of plant collectors in Bolivia. Smithsonian Contributions to Botany, (70), 1–20. doi:[10.5479/si.0081024x.70](https://doi.org/10.5479/si.0081024x.70)  also [BHL](https://www.biodiversitylibrary.org/bibliography/131635)



## Random thoughts

We can frame question as being “given this name string, what person does it correspond too?” This means we take a name and try and match it to names in  trusted source, e.g. Wikidata.

But if problem is really “I have this name string on a label, who is it?” then we potentially have other information, such as taxon, date, and location. Imagine that we have an authoritative database of who studied what species and when (e.g., IPNI for plants), then we could generate “all” possible labels that could be generated from that data, such as (person name, species, date), and then we match observed label data to that dataset. The best match is likely to be a good candidate for being the actual person.

Could you take this approach to Wikidata itself? Say you construct SPARQL queries based on the other information you have. Then you process the results based on similarity of their item label to the person name text string provided. As long as the person is in wikidata, the other information provided is also set in Wikidata and a query can be made sufficiently comprehensive to cover all people who collected specimens, this should work?

Then we could set the scope of this STSM: 

- how good is wikidata's coverage of specimen collectors?
- how comprehensive is wikidata's information on those people (probably focus on a few key properties)?
- (how) are specimen-collecting people consistently modeled in wikidata?
- demo of this approach?
