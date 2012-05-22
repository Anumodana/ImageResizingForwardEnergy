import java.awt.*;
import java.awt.event.KeyEvent;
import java.io.File;

		/**
		 * Seam carving forward energy
		 */
		PImage img;
		float[][] imgMValue,cl,cu,cr,imgRGB;
		int[][] imgKTrack,tempP;
		float minEnergy;
		float[] minMValue,r,g,b;
		int[] mx,my;
		int x2,y2,loc,wid,hei,i=0,c=0;
		String filename,dir;
		void setup()
		{
			FileDialog filedialog = new FileDialog(frame, "Choose an image file");
			filedialog.setVisible(true);
			filename = filedialog.getFile();
			dir = filedialog.getDirectory();
			img = loadImage(dir+File.separator+filename);
			wid=img.width;
	                hei=img.height;
	                imgRGB = new float[wid][hei];
			cl = new float[wid][hei];
			cu = new float[wid][hei];
			cr = new float[wid][hei];
                        r = new float[img.pixels.length];
    	                g = new float[img.pixels.length];
    	                b = new float[img.pixels.length];
			imgMValue = new float[wid][hei];
		  	minMValue = new float[hei];
                        imgKTrack = new int[wid][hei];
		  	mx = new int[hei];
		  	my = new int[hei];
    	                tempP = new int[wid][hei];
    	                size(wid,hei);
    	                image(img,0,0);
		}
		public void draw()
		{
			img.loadPixels();
                        calRGB();
			calEnergy();
			calSeamAndKMatrix();
			calMinMVertical();
                        /*
			if(keyPressed&&wid>1)
			{
			  if(keyCode==KeyEvent.VK_LEFT)
		          {
                              calRGB();
			      calEnergy();
			      calSeamAndKMatrix();
			      calMinMVertical();
			      shiftPixels();
			      size(wid,hei);
    	       		      image(img,0,0);
		          }
			}
                        else if (wid==1)
                        {stop();}*/
		}// end void draw
        public void keyPressed()
        {
	          if(keyCode==KeyEvent.VK_LEFT)
	          {
	        	  if (wid==1)
			      {stop();}
	        	  else
	        	  {
			             /* calRGB();
				      calEnergy();
				      calSeamAndKMatrix();
				      calMinMVertical();*/
				      shiftPixels();
				      size(wid,hei);
				      image(img,0,0);
	        	  }
			      
	          }
         }
	//////////////////////////////////////////////Methods///////////////////////////////////////////////////	
		
		public void calRGB()
		  {
			  // Calculation RGB
			  //System.out.println("Start finding RGB!");
			  for (int y=0;y<hei;y++)
			  {
			    for (int x=0;x<wid;x++)
			    {
			      loc = x + y*img.width;
			      r[loc] = red (img.pixels[loc]);
			      g[loc] = green (img.pixels[loc]);
			      b[loc] = blue (img.pixels[loc]);
			      imgRGB[x][y]=r[loc]+g[loc]+b[loc];
			      //System.out.print(imgRGB[x][y]+"("+loc+")  ");
			      tempP[x][y]=img.pixels[loc];
			    }// end for x (RGB)
			    minMValue[y]=0;//set all minMValue = 0
			    //System.out.println();
			  }// end for y (RGB)
			  
		  }
		
		  public void calEnergy()
		  {
			  //System.out.println("Start finding energy! [Forward]");
			  //Calculation energy
			 for (int y=0;y<hei;y++)
			 {
			   for (int x=0;x<wid;x++)
			   {
			     if (y==0) // The first row
			     {
			       if (x==0)
			       {//left corner (0,0)
			    	   	cl[x][y]=abs(imgRGB[x+1][y]-imgRGB[x][y])+abs(imgRGB[x][y]-imgRGB[x][y]);
			        	cu[x][y]=abs(imgRGB[x+1][y]-imgRGB[x][y]);
			        	cr[x][y]=abs(imgRGB[x+1][y]-imgRGB[x][y])+abs(imgRGB[x][y]-imgRGB[x+1][y]);
			       }
			       else if(x==wid-1)
			       {//right corner (width-1,0)
			    	   	cl[x][y]=abs(imgRGB[x][y]-imgRGB[x-1][y])+abs(imgRGB[x][y]-imgRGB[x-1][y]);
			        	cu[x][y]=abs(imgRGB[x][y]-imgRGB[x-1][y]);
			        	cr[x][y]=abs(imgRGB[x][y]-imgRGB[x-1][y])+abs(imgRGB[x][y]-imgRGB[x][y]);
			       }
			       else
			       {
			    	        cl[x][y]=abs(imgRGB[x+1][y]-imgRGB[x-1][y])+abs(imgRGB[x][y]-imgRGB[x-1][y]);
			        	cu[x][y]=abs(imgRGB[x+1][y]-imgRGB[x-1][y]);
			        	cr[x][y]=abs(imgRGB[x+1][y]-imgRGB[x-1][y])+abs(imgRGB[x][y]-imgRGB[x+1][y]);
			       }
			     }
			     else // y!=0
			     {
			       if (x==0)
			       {
			    	        cl[x][y]=abs(imgRGB[x+1][y]-imgRGB[x][y])+abs(imgRGB[x][y-1]-imgRGB[x][y]);
			        	cu[x][y]=abs(imgRGB[x+1][y]-imgRGB[x][y]);
			        	cr[x][y]=abs(imgRGB[x+1][y]-imgRGB[x][y])+abs(imgRGB[x][y-1]-imgRGB[x+1][y]);
			       }
			       else if(x==wid-1)
			       {//right (width-1,y)
			    	        cl[x][y]=abs(imgRGB[x][y]-imgRGB[x-1][y])+abs(imgRGB[x][y-1]-imgRGB[x-1][y]);
			        	cu[x][y]=abs(imgRGB[x][y]-imgRGB[x-1][y]);
			        	cr[x][y]=abs(imgRGB[x][y]-imgRGB[x-1][y])+abs(imgRGB[x][y-1]-imgRGB[x][y]);
			       }
			       else
			       {
			    	        cl[x][y]=abs(imgRGB[x+1][y]-imgRGB[x-1][y])+abs(imgRGB[x][y-1]-imgRGB[x-1][y]);
			        	cu[x][y]=abs(imgRGB[x+1][y]-imgRGB[x-1][y]);
			        	cr[x][y]=abs(imgRGB[x+1][y]-imgRGB[x-1][y])+abs(imgRGB[x][y-1]-imgRGB[x+1][y]);
			       }
			     }// end if y=0
			   }//end for x (energy)
			   //System.out.println();
			 } //end for y (energy)
		  }
		
		  public void calSeamAndKMatrix()
		  {
			  //System.out.println("Start finding the best seam! [Forward]");
			  for (int y=0;y<hei;y++)
			  {
			    for (int x=0;x<wid;x++)
			    {
			      loc = x + y*wid;
			      //first row, no calculation the best seam
			      //start calculation the best seam at the next row
			      if (y!=0)
			      {
			        if (x==0)
			        {//find M (0,y>0)
			          imgMValue[x][y]=min(imgMValue[x][y-1]+cu[x][y],imgMValue[x+1][y-1]+cr[x][y]);
			          if (imgMValue[x][y]==imgMValue[x+1][y-1]+cr[x][y])
			          {imgKTrack[x][y]=3;}
			          else
			          {imgKTrack[x][y]=2;}
			        }
			        else if (x==wid-1)
			        {//find M (width-1,y>0)
			          imgMValue[x][y]=min(imgMValue[x-1][y-1]+cl[x][y],imgMValue[x][y-1]+cu[x][y]);
			          if (imgMValue[x][y]==imgMValue[x][y-1]+cu[x][y])
			          {imgKTrack[x][y]=2;}
			          else
			          {imgKTrack[x][y]=1;}
			        }
			        else
			        {
			          imgMValue[x][y]=min(imgMValue[x-1][y-1]+cl[x][y],imgMValue[x][y-1]+cu[x][y],imgMValue[x+1][y-1]+cr[x][y]);
			          if (imgMValue[x][y]==imgMValue[x+1][y-1]+cr[x][y])
			          {imgKTrack[x][y]=3;}
			          else if (imgMValue[x][y]==imgMValue[x][y-1]+cu[x][y])
			          {imgKTrack[x][y]=2;}
			          else
			          {imgKTrack[x][y]=1;}
			        }
			      }
			      else //y=0
			      {
			        imgMValue[x][y]=min(cl[x][y],cu[x][y],cr[x][y]);
			        imgKTrack[x][y]=0;
			      }//end if-else y=1
			      //System.out.print(imgMValue[x][y]+"("+loc+")  ");
			    }//end for x (best seam)
			    //System.out.println();
			  }//end for y (best seam)
		  }

		public void calLastRow()
		{
                  int y=hei-1;
		  minMValue[y]=imgMValue[0][y];
		    for (int x=0;x<wid;x++)
		    {
		      if (minMValue[y]>=imgMValue[x][y])
		      {
		        minMValue[y]=imgMValue[x][y];
		        mx[y]=x;
		        my[y]=y;
		      }
		    }
		  }// end calLastRow
		
		  public void calMinMVertical()
		  {
			  calLastRow();
			  for (int y=hei-1;y>=0;y--)
			  {
			    for (int x=0;x<wid;x++)
			    {
			    	if(y<hei-1)
			    	{
			    		if(mx[y+1]==0)
			    		{
					    	if (imgMValue[mx[y+1]][y]<imgMValue[mx[y+1]+1][y])
					    	{
					    		minMValue[y]=imgMValue[mx[y+1]][y];
					    		mx[y]=mx[y+1];
					    	}
					    	else
					    	{
					    		minMValue[y]=imgMValue[mx[y+1]+1][y];
					    		mx[y]=mx[y+1]+1;
					    	}
					        my[y]=y;
					    }
			    		else if(mx[y+1]==wid-1)
			    		{
			    			if (imgMValue[mx[y+1]][y]<imgMValue[mx[y+1]-1][y])
					    	{
					    		minMValue[y]=imgMValue[mx[y+1]][y];
					    		mx[y]=mx[y+1];
					    	}
					    	else
					    	{
					    		minMValue[y]=imgMValue[mx[y+1]-1][y];
					    		mx[y]=mx[y+1]-1;
					    	}
			    			my[y]=y;
			    		}
			    		else
			    		{
			    			if (imgMValue[mx[y+1]][y]<imgMValue[mx[y+1]-1][y]&&imgMValue[mx[y+1]][y]<imgMValue[mx[y+1]+1][y])
					    	{
					    		minMValue[y]=imgMValue[mx[y+1]][y];
					    		mx[y]=mx[y+1];
					    	}
					    	else if (imgMValue[mx[y+1]+1][y]<imgMValue[mx[y+1]-1][y]&&imgMValue[mx[y+1]+1][y]<imgMValue[mx[y+1]][y])
					    	{
					    		minMValue[y]=imgMValue[mx[y+1]+1][y];
					    		mx[y]=mx[y+1]+1;
					    	}
					    	else
					    	{
					    		minMValue[y]=imgMValue[mx[y+1]-1][y];
					    		mx[y]=mx[y+1]-1;
					    	}
			    			my[y]=y;
			    		}
			    	}
			    }// end for x (Find min M)
			    stroke(225, 214, 41);
			    point(mx[y],my[y]);
			    //System.out.print(imgRGB[mx[y]][my[y]]+"("+(mx[y]+my[y]*wid)+")RGB\t");
			    //System.out.println(minMValue[y]+"("+(mx[y]+my[y]*wid)+")\t");
			  }// end for y (Find min M)
		  }
		  
		  public void shiftPixels()
		  {
			  PImage nImg = createImage(wid-1,hei,RGB); 
			  //System.out.println("\nBegin shifting");
			  for (int y=0;y<hei;y++)
			  {
				  x2=mx[y];
				  y2=my[y];     
				  for (int x=0;x<wid;x++)
				  {
	                  loc = x + y*wid;
					  if (x2<wid-1&&x!=wid-1)
					  {
						  /*
						  imgKTrack[x2][y2]=imgKTrack[x2+1][y2];
						  imgMValue[x2][y2]=imgMValue[x2+1][y2];
	                      imgRGB[x2][y2]=imgRGB[x2+1][y2];
	                      */
	                      tempP[x2][y2]=tempP[x2+1][y2];
	                      x2++;
					  }
	                  //System.out.print(imgRGB[x][y]+"("+loc+")  ");
	                  //System.out.print(tempP[x][y]+"("+loc+")  ");
				  }//end for x
				  //System.out.println();
			  }//end for y
			  for (int y=0;y<hei;y++)
			  {
				  for (int x=0;x<wid-1;x++)
				  {
					  loc = x + y*wid;
					  nImg.pixels[i++]=tempP[x][y];
					  //System.out.print(nImg.pixels[i-1]+"("+(i-1)+")  ");
				  }//end for x
				  //System.out.println();
			  }//end for y
			  i=0;
			  img=nImg;
			  img.updatePixels();
			  wid=img.width;
			  for (int y=0;y<hei;y++)
			  {
				  for (int x=0;x<wid;x++)
				  {
					  loc = x + y*wid;
					  //System.out.print(img.pixels[loc]+"("+loc+")  ");
				  }//end for x
				  //System.out.println();
			  }//end for y
	          //System.out.println("End shifting");
	          //stop();
		  }//end Shift

