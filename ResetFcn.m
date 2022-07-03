function in = ResetFcn(in)

    smiData.RevoluteJoint(5).Rz.Pos = 0.0;
    smiData.RevoluteJoint(5).ID = '';

    smiData.RevoluteJoint(1).Rz.Pos = 0.43901116816976632;  % deg
    smiData.RevoluteJoint(1).ID = '[czlon2:-:czlon1]';

    smiData.RevoluteJoint(2).Rz.Pos = -99.788223866032055;  % deg
    smiData.RevoluteJoint(2).ID = '[czlon3:-:czlon2]';

    smiData.RevoluteJoint(3).Rz.Pos = -12.935663478674593;  % deg
    smiData.RevoluteJoint(3).ID = '[czlon4:-:czlon3]';

    smiData.RevoluteJoint(4).Rz.Pos = -64.63097096185983;  % deg
    smiData.RevoluteJoint(4).ID = '[czlon5:-:czlon4]';

    smiData.RevoluteJoint(5).Rz.Pos = -117.78386196709498;  % deg
    smiData.RevoluteJoint(5).ID = '[czlon6:-:czlon5]';
    
    desire_position = [0, -12.4675, 16.2833, 11.7267];
   
end