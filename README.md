Docker image for the paper:
Selvi, J., Rodríguez, R. J., &amp; Soria-Olivas, E. (2019). Detection of algorithmically generated malicious domain names using masked N-grams. Expert Systems with Applications, 124, 156-163.

The image has been uploaded to docker hub, so you can run it from there:
```
docker run -ti jselvi/r-masked-ngrams
```

You can also build it yourself if you prefer so:
```
docker build -t jselvi/r-masked-ngrams .
```

Finally, after a while, you should have the following results:
```
Confusion Matrix and Statistics

          Reference
Prediction CLEAN MALWARE
   CLEAN   12565     269
   MALWARE   229   12531

               Accuracy : 0.9805
                 95% CI : (0.9788, 0.9822)
    No Information Rate : 0.5001
    P-Value [Acc > NIR] : < 2e-16

                  Kappa : 0.9611

 Mcnemar's Test P-Value : 0.08053

            Sensitivity : 0.9821
            Specificity : 0.9790
         Pos Pred Value : 0.9790
         Neg Pred Value : 0.9821
             Prevalence : 0.4999
         Detection Rate : 0.4909
   Detection Prevalence : 0.5014
      Balanced Accuracy : 0.9805

       'Positive' Class : CLEAN
```
