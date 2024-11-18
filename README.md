Oppgave 1

Workflow kjørt : https://github.com/mcflonilo/eksamendevops/actions/runs/11857037651/job/33044545542

Oppgave 2

Push til main : https://github.com/mcflonilo/eksamendevops/actions/runs/11857156888

Push til branch : https://github.com/mcflonilo/eksamendevops/actions/runs/11891474232

Sqs url : https://sqs.eu-west-1.amazonaws.com/244530008913/image-prompt-queue-35

Oppgave 3

Jeg bruker en tagstrategi for Docker-images som sikrer både unik identifikasjon, fleksibilitet og enkel tilgang. Jeg benytter SHA-basert tagging for å knytte hvert bilde til en spesifikk commit, noe som gir alle images en unik tag og hjelper med historisk debugging. "Latest"-taggen er også viktig, da den alltid peker på det nyeste bildet, noe som er praktisk under utvikling og testing. I tillegg bruker jeg branch-spesifikke tags, der jeg erstatter / med - i branch-navnet, for å tillate samtidig arbeid på flere branches. Dette gir god oversikt og hjelper med å deploye fra bestemte branches. Denne kombinasjonen av tags gir både sporbarhet og brukervennlighet, som er viktig for effektivt arbeid og feilretting.

Image: docker run -e AWS_ACCESS_KEY_ID=xxx -e AWS_SECRET_ACCESS_KEY=yyy -e SQS_QUEUE_URL=https://sqs.eu-west-1.amazonaws.com/244530008913/image-prompt-queue-35 mcflonilo/eksamendevopskandidat35:latest "Glenn teaching DevOps principles to the class"

oppgave 5
1.	Automatisering og kontinuerlig levering.

Serverless-arkitektur legger opp til høy grad av automatisering i CI/CD-pipelines, hvor testing, bygging og utrulling av statsløse funksjoner håndteres ved hjelp av plattformverktøy som AWS SAM og Serverless Framework. Dette muliggjør rask implementering, men øker kompleksiteten med separate pipelines for hver funksjon. Utrulling strategier for serverless, som utnytter infrastruktur som kode (IaC), sikrer konsistens, minimal nedetid og dynamisk skalering. Mikrotjenester, derimot, krever modulære pipelines med verktøy som Docker og Kubernetes, hvor hver tjeneste deployeres uavhengig. Strategier som blå-grønn utrulling og kanarilanseringer gir kontroll over endringer, men krever mer koordinert administrasjon av tjenester og avhengigheter.

2.	Overvåkning.

Når man går fra mikrotjenester til serverless arkitektur, blir overvåkning, logging og feilsøking mer utfordrende. Mikrotjenester kan logges og overvåkes individuelt, noe som gir god innsikt i ytelsen til hver tjeneste. I serverless blir dette vanskeligere på grunn av den statsløse og hendelsesdrevne naturen til funksjonene, som skaleres automatisk. Dette fører til fragmenterte loggdata, og det blir utfordrende å spore problemer over flere funksjoner og hendelser. I tillegg kan det være mangel på sammenhengende sporing over funksjoner som kjører på ulike instanser og tidspunkter, noe som gjør feilsøking vanskeligere. Spesifikke verktøy som AWS X-Ray og CloudWatch brukes for å håndtere disse utfordringene, men overvåkning i serverless arkitektur krever mer tilpasset løsning og innsikt i både funksjoner og eksterne avhengigheter.

3.	Skalerbarhet og kostnadskontroll.

serverless arkitektur skalerer automatisk med bruk noe som hindrer unødvendig ressursbruk men også sikrer at tjenester fungerer som de skal når det er høy etterspørsel. en ulempe med serverless er at det kan være "cold start latency" på funksjoner som ikke brukes så ofte dette gjør de mindre responsive.

for ressursbruk er serveerless arkitektur veldig bra siden funksjoner kun kjører når de blir kalt på som reduserer idle tid som igjen senker kostnader. en ulempe er at siden man ikke hat full kontroll over den underliggende infrastrukturen kan dette føre til uventede problemer i noen tilfeller.

en fordel for serverless på kostnadsoptimering er at man kan velge forskjellige planer for eksempel pay-per-use, her betaler du kun for nøyaktig den tiden funksjonen kjører som kan være veldig kostnadseffektivt for sporadisk bruk av funksjoner. en ulempe er at det kan bli dyrt hvis du har mange funksjoner som kaller på andre funksjoner siden brukstiden da går fort opp.

Mikrotjenester kan skaleres uavhengig av hverandre, dette gjør at du kan øke tilgjengelige ressurser for de mest brukte/tyngste tjenestene og senke for de mindre/lettere tjenestene. En ulempe for mikrotjenesters skalerbarhet er at det kan bli komplekst og man trenger en orkestreringstjeneste som for eksempel Kubernetes.

En fordel til mikrotjenester for ressursbruk er at du har full kontroll over ressursfordeling og kan optimere for hver enkelt tjeneste, en ulempe er at dette krever god monitorering for å unngå bortkastet ressursbruk.

Man kan oppnå høy kostnadseffektivitet med mikrotjenester siden du kan skalere nøyaktig de delene som trenger skalering i motsetning til å måtte skalere hele applikasjonen. en ulempe er at du får ekstra kostnader på grunn av behovet for orkestreringsverktøy

4.	Ansvar 
I en overgang fra mikrotjenester til serverless vil ansvaret for servere infrastruktur og skalering gå over på skyleverandøren, dette vil gi teamet mer kapasitet til å fokusere på ytelse og funksjonalitet, men senker kontrollen til teamet over underliggende ressurser. Det kan også senke kostnadene til teamet siden de vil bare betale for ressurser brukt i motsetning til en mikrotjeneste arkitektur hvor man ofte betaler for maks kapasiteten til serveren uavhengig av belastning.
