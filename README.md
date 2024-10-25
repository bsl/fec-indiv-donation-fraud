## FEC individual donor fraud report

- Go to the FEC's [bulk data page](https://www.fec.gov/data/browse-data/?tab=bulk-data).
- Choose the `Contributions by individuals` tab.
- Download a recent archive, probably `indiv24.zip`. Put it in `data/` relative to this script and unpack it. Make sure `data/itcont.txt` exists.
- `ruby go.rb > report.txt`

## What's in the report?

```
# AK|ANCHORAGE
9032|$109698|SCOTT, THOMAS|99504|13.6 times per day|D
```

This means that Scott Thomas of Anchorage donated 9032 times over 2023-2024, an average of 13.6 times per day, for a total of over $100k. Does that seem odd to you? It seems odd to me.

Or what about this?

```
# CA|LOS ANGELES
12094|$46099|POHOST, GERALD|90005|18.2 times per day|R
```

Gerald Pohost in L.A. donated over 12k times in 2023-2024, more than once for every single waking hour. He's a very busy guy. He doesn't even stop for lunch.

```
# CO|DENVER
15630|$260486|GRISWOLD, EDSON|80231|23.6 times per day|D
```

Edson Griswold in Denver is even more serious about donations, making a donation almost every single hour of the day, every single day, for two years straight. Now that's dedication.

But the corruption situation in the US is currently so severe that you can literally generate a report of criminal activity based on the government's own data, and send it to authorities, and nothing will happen.

## Code

This code is really bad, but it seems to work. Please send PRs if you want. Thanks.
