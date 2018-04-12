using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using System.IO;
using System.Diagnostics;

/*********************   OPTIMIZATION PROBLEM   ************************/
/***********************************************************************/

class Optimizationproblem {
    
    public static void blackbox( double[] f, double[] g, double[] x, double num_people,  double wall_thick, double vol_pp ) 
    {
        double L = x[0];
        double W = x[1];
        double H = x[2];
        //double wall_thick = .05; //wall thickness, m
        //double num_people = 5;
        //double vol_pp = 10; //volume per person, m^3

        /* Objective functions F(X) */
        double vol_material = (L + wall_thick) * (W + wall_thick) * (H + wall_thick) - (L * W * H);
        f[0] = vol_material;

        /* Equality constraints G(X) = 0 MUST COME FIRST in g[0:me-1] */
        g[0] = -vol_pp + (L * W * H) / num_people;
        g[1] = L - 2;
        g[2] = W - 1;
        g[3] = H - 1;
        g[4] = 3 - H;
       
    }
} 
/***********************************************************************/
/************************   MAIN PROGRAM   *****************************/
/***********************************************************************/
class Example {

  public static void Main(string[] args) {

      long i,n; double[] x,xl,xu;
      Dictionary<string, long> problem = new Dictionary<string, long>();
      Dictionary<string, long> option  = new Dictionary<string, long>();
      Dictionary<string, double> parameter  = new Dictionary<string, double>();
      Dictionary<string, double[]> solution   = new Dictionary<string, double[]>();
      string key = "MIDACO_LIMITED_VERSION___[CREATIVE_COMMONS_BY-NC-ND_LICENSE]";
      
      /*****************************************************************/
      /***  Step 1: Problem definition  ********************************/
      /*****************************************************************/

      /* STEP 1.A: Problem dimensions
      ******************************/
      problem["o"]  = 1; /* Number of objectives                          */
      problem["n"]  = 3; /* Number of variables (in total)                */
      problem["ni"] = 0; /* Number of integer variables (0 <= ni <= n)    */
      problem["m"]  = 5; /* Number of constraints (in total)              */
      problem["me"] = 0; /* Number of equality constraints (0 <= me <= m) */

      /* STEP 1.B: Lower and upper bounds 'xl' & 'xu'  
      **********************************************/ 
      n = problem["n"]; 
      xl = new double[n]; 
      xu = new double[n]; 
      for(i=0;i<n;i++)
      { 
         xl[i] = 1.0;
         xu[i] = 100; 
      }

      /* STEP 1.C: Starting point 'x'  
      ******************************/          
      x  = new double[n]; 
      for(i=0;i<n;i++)
      { 
         x[i] = xl[i]; /* Here for example: starting point = lower bounds */ 
      } 
      
      /*****************************************************************/
      /***  Step 2: Choose stopping criteria and printing options   ****/
      /*****************************************************************/
                  
      /* STEP 2.A: Stopping criteria 
      *****************************/
      option["maxeval"] = 1000;    /* Maximum number of function evaluation (e.g. 1000000)  */
      option["maxtime"] = 60*60*24; /* Maximum time limit in Seconds (e.g. 1 Day = 60*60*24) */

      /* STEP 2.B: Printing options  
      ****************************/
      option["printeval"] = 1000; /* Print-Frequency for current best solution (e.g. 1000) */
      option["save2file"] = 1;    /* Save SCREEN and SOLUTION to TXT-files [ 0=NO/ 1=YES]  */          

      /*****************************************************************/
      /***  Step 3: Choose MIDACO parameters (FOR ADVANCED USERS)    ***/
      /*****************************************************************/

      parameter["param1"]  = 0.0; /* ACCURACY  */
      parameter["param2"]  = 0.0; /* SEED      */
      parameter["param3"]  = 0.0; /* FSTOP     */
      parameter["param4"]  = 0.0; /* ALGOSTOP  */
      parameter["param5"]  = 0.0; /* EVALSTOP  */
      parameter["param6"]  = 0.0; /* FOCUS     */
      parameter["param7"]  = 0.0; /* ANTS      */
      parameter["param8"]  = 0.0; /* KERNEL    */
      parameter["param9"]  = 0.0; /* ORACLE    */
      parameter["param10"] = 0.0; /* PARETOMAX */
      parameter["param11"] = 0.0; /* EPSILON   */
      parameter["param12"] = 0.0; /* BALANCE   */
      parameter["param13"] = 0.0; /* CHARACTER */   
 
      /*****************************************************************/
      /***  Step 4: Choose Parallelization Factor    *******************/
      /*****************************************************************/  

      option ["parallel"] = 0; /* Serial: 0 or 1, Parallel: 2,3,4,... */

        /*****************************************************************/
        /***********************  Run MIDACO  ****************************/
        /*****************************************************************/

        //Define the numbers read in from the exe file
        string num_s = args[0]; //Number of People
        string wall_s = args[1]; //Wall Thickness (m)
        string vol_pp_s = args[2]; //Personal Space Volume minimum (m^3)

        double num = double.Parse(num_s);
        double wall = double.Parse(wall_s);
        double vol_pp = double.Parse(vol_pp_s);
        solution = Midaco.run ( problem, x,xl,xu, option, parameter, key, num, wall, vol_pp);

      /* Print solution return arguments from MIDACO to console */
      
      double[] f,g;
        f = solution["f"];
        g = solution["g"];
        x = solution["x"];

        double L = x[0];
        double W = x[1];
        double H = x[2];
        

        double vol_material = f[0];
        double vol_habitat = L*W*H;
        double vol_personal = vol_habitat/num;

        Console.WriteLine(" ");
        Console.WriteLine("L value: " + L);
        Console.WriteLine("W value: " + W);
        Console.WriteLine("H value: " + H);
        Console.WriteLine("Total Inside Volume: " + vol_habitat);
        Console.WriteLine("Material Volume: " + vol_material);
        Console.WriteLine("Personal Volume: " + vol_personal);

        File.WriteAllText("Optimized_Habitat.txt", L + " " + W + " " + H + " " + vol_material + " " + vol_personal);

      /*****************************************************************/
      /***********************  END OF MAIN  ***************************/
      /*****************************************************************/        
  }
}

