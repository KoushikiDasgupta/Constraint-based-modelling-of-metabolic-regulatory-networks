%Simulating FBA,dFBA and rdFBA on the core carbon model in Covert et al
%2001
R1 = 'A + ATP -> B';
R2a = 'B -> 2 ATP + 2 NADH + C ';
R2b = 'C + 2 ATP + 2 NADH -> B';
R3 = 'B -> F';
R4 = 'C -> G';
R5a = 'G -> 0.8 C + 2 NADH';
R5b = 'G -> 0.8 C + 2 NADH';
R6 = 'C -> 2 ATP + 3 D';
R7 = 'C + 4 NADH -> 3 E';
R8a = 'G + ATP + 2 NADH -> H';
R8b = 'H -> G + ATP + 2 NADH';
Rres = 'NADH + O2 -> ATP';
Tc1 = 'Carbon1[e] -> A';
Tc2 = 'Carbon2[e] -> A';
Tf = 'Fext[e] -> F';
Td = 'D -> Dext[e]';
Te = 'E -> Eext[e]';
Th = 'Hext[e] -> H';
To2 = 'Oxygen[e] -> O2';
Gro = 'C + F + H + 10 ATP -> ';
grRuleR1 ='';
grRuleR2a ='tR2a';
grRuleR2b ='';
grRuleR3 ='';
grRuleR4 ='';
grRuleR5a ='tR5a';
grRuleR5b ='tR5b';
grRuleR6 ='';
grRuleR7 ='tR7';
grRuleR8a ='tR8a';
grRuleR8b ='';
grRuleRres ='tRres';
grRuleGro ='';
grRuleTc1 ='';
grRuleTc2 ='tTc2';
grRuleTf ='';
grRuleTd ='';
grRuleTe ='';
grRuleTh ='';
grRuleTo2 ='';
grRuleList = {grRuleR1,grRuleR2a,grRuleR2b,grRuleR3,grRuleR4,grRuleR5a,grRuleR5b,grRuleR6,grRuleR7,grRuleR8a,grRuleR8b,grRuleRres,grRuleGro,grRuleTc1,grRuleTc2,grRuleTf,grRuleTd,grRuleTe,grRuleTh,grRuleTo2};
reactionIdentifiers = {'R1','R2a','R2b','R3','R4','R5a','R5b','R6','R7','R8a','R8b','Rres','Gro','Tc1','Tc2','Tf','Td','Te','Th','To2'};
reactionNames = {'R1','R2a','R2b','R3','R4','R5a','R5b','R6','R7','R8a','R8b','Rres','Gro','Tc1','Tc2','Tf','Td','Te','Th','To2'};
reactionFormulas = {R1,R2a,R2b,R3,R4,R5a,R5b,R6,R7,R8a,R8b,Rres,Gro,Tc1,Tc2,Tf,Td,Te,Th,To2};
lowerBounds =[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
upperBounds = [1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,10.5,10.5,5,12,12,5,15];
model=createModel(reactionIdentifiers,reactionNames,reactionFormulas,'upperBoundList',upperBounds,'lowerBoundList',lowerBounds,'grRuleList',grRuleList);
model = addReaction(model,'EX_Carbon1','metaboliteList',{'Carbon1[e]'},'stoichCoeffList', [-1]);
model = addReaction(model,'EX_Carbon2','metaboliteList',{'Carbon2[e]'},'stoichCoeffList', [-1]);
model = addReaction(model,'EX_Fext','metaboliteList',{'Fext[e]'},'stoichCoeffList', [-1]);
model = addReaction(model,'EX_Hext','metaboliteList',{'Hext[e]'},'stoichCoeffList', [-1]);
model = addReaction(model,'EX_Dext','metaboliteList',{'Dext[e]'},'stoichCoeffList', [-1]);
model = addReaction(model,'EX_Eext','metaboliteList',{'Eext[e]'},'stoichCoeffList', [-1]);
model = addReaction(model,'EX_Oxygen','metaboliteList',{'Oxygen[e]'},'stoichCoeffList', [-1]);
model = changeObjective(model,'Gro',1);
model.regulatoryGenes = {'tR2a','tR5a','tR5b','tR7','tR8a','tRres','tTc2'};
model.regulatoryInputs1 = {'Carbon1[e]','Oxygen[e]'};%(extracellular metabolites)
model.regulatoryInputs2 = {'R2b','Th'};%list of input names(reactions)
model.regulatoryRules = {'~R2b'
    'Oxygen[e]'
    '~Oxygen[e]'
    '~R2b'
    '~Th'
    'Oxygen[e]'
    '~Carbon1[e]'};
%printFluxBounds(model);
% FBAsolution = optimizeCbModel(model,'max');
% FBAsolution.f

%for growth on carbon2 and amino acid cases, uncomment
%model = changeRxnBounds(model,'EX_Carbon1',0,'l'); 

%for anaerobic growth
%model = changeRxnBounds(model,'EX_Oxygen',0,'l'); 
if usejava('desktop') % This line of code is to avoid execution of example in non gui-environments
writeCbModel(model, 'fileName', 'CoreCarbonModel.xml')
end

timeStep = 0.001;
nSteps = 4000;
inConc = [10,10,0,0,0,0];
reac = {'EX_Carbon1','EX_Carbon2','EX_Fext','EX_Hext','EX_Dext','EX_Eext'};
% dynamicFBA(model,reac,inConc,0.1,timeStep,nSteps,{'EX_Carbon1'});
dynamicRFBA(model,reac,inConc,0.1,timeStep,nSteps,{'EX_Carbon1','EX_Carbon2'},{'EX_Oxygen'});