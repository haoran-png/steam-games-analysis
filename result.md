# Summary

1. `Genres`  
**Creative** and **utility-focused** genres achieve the *highest ratings and longest playtimes*, while **RPGs** and **simulations** sustain *long play with average ratings*. **MMOs** draw *heavy engagement but lower satisfaction*, and **casual** or **niche** genres consistently underperform.  

2. `Pricing`  
Free games maximize reach but offer no value per euro (though some may generate revenue through microtransactions, which remains uncertain). The best *value for money* lies in the **€5–€10 range**, with a secondary peak at **€15–€20**. Mid-range (€20–€50) is balanced, **€55–€60** shows *strong reach but low satisfaction*, and high-end (€60+) consistently *underperforms*. Value tends to concentrate in the **x5–x0 price buckets**.  

3. `Tags`  
*High-lift tags* like **nostalgia**, **cult classic**, and **crowdfunded** are the *most predictive of strong ratings*. Broader tags such as **story rich** or **anime** are *less extreme but more impactful* due to their prevalence. Tag combinations matter: overlaps between narrative and identity-driven tags amplify success, while narrow technical pairings dilute it.  

4. `Sentiment Over Time`  
*Ratings declined* through the **mid-2000s**, *bottoming out* in **2013–2014**, then *recovered steadily* from **2015 onward**. Newer releases (**2018–2025**) are generally *reviewed more favorably*. Blockbuster titles remain instability, with dips in **2017** and **2023**, while release volume surged after 2014, largely driven by small titles.  

5. `Developer Strategies (Tags)`  
Some strategies reliably boost ratings across studios — notably **2D design**, **atmospheric feel**, **moddability**, **classic themes**, and **strong soundtracks** — though gains are modest. Larger improvements often come from studio-specific approaches. The strongest outcomes combine proven signals with a studio’s **creative direction** and **market focus**.  

**Overall:** The analysis shows that long-term engagement and high ratings come from genres and tags that support creativity and depth, while value for money is concentrated in lower price ranges. Sentiment has improved in recent years, but instability remains for major releases. Developers succeed by blending repeatable strategies with their own unique identity.  


# Possible Improvements

Working on this project gave me valuable insight into both the technical and interpretive sides of data analysis. Many of my early mistakes could have been avoided with a more thoughtful process, but they also helped me understand where the biggest opportunities to improve lie.  

- `Data handling:` I ran into issues with encoding, file size, and inconsistent rows. I first tried solving them by reading the file in chunks, which only made the process slower and more complicated. In the end, the real issue was that I had been reading the file incorrectly from the start, which could have be a bit time saver.  

- `Developer strategies:` When working on the question about developer strategies, I noticed the “indie” tag. Looking back, I could have added a comparison between indie titles and AAA studios across different metrics. That would have given a more balanced view of how different kinds of developers approach success.  

- `Future extension:` The analysis so far is descriptive, but a natural next step would be to add a machine learning section. Using models to predict success based on tag combinations, pricing, and other features could turn these insights into forecasts and bring the project closer to real world data science work.  