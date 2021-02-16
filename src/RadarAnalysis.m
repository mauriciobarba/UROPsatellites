function r = RadarAnalysis(root)
scenario = root.CurrentScenario();
satellite = root.GetObjectFromPath("Satellite/testsat");
radar = root.GetObjectFromPath('Place/facility_1/Radar/Radar');
access = satellite.GetAccessToObject(radar);
access.ComputeAccess;

phased = radar.Model.AntennaControl.EmbeddedModel;
phased.BeamDirectionProvider.Directions.AddObject(satellite)
Probability = access.DataProviders.Item('Radar SearchTrack').Exec(scenario.StartTime,scenario.StopTime,60);
TotalProbability = [];
for i = 0:Probability.Interval.Count-1
    SomeProbability = cell2mat(Probability.Interval.Item(int32(i)).DataSets.GetDataSetByName('S/T PDet1').GetValues);
    TotalProbability = cat(1,TotalProbability,SomeProbability);
end
phased.BeamDirectionProvider.Directions.RemoveAll()
bar(TotalProbability);
title('Probability of Detection Over Time');
xlabel('Time')
ylabel('Probability of Detection')
r = max(TotalProbability);