/*
  Warnings:

  - The values [IN_PROGRESS] on the enum `OrderStatus` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `cretatedAt` on the `OrderProduct` table. All the data in the column will be lost.
  - You are about to drop the column `restaurantId` on the `OrderProduct` table. All the data in the column will be lost.
  - You are about to drop the column `restaurantID` on the `Product` table. All the data in the column will be lost.
  - The `ingredients` column on the `Product` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - Added the required column `restaurantId` to the `Product` table without a default value. This is not possible if the table is not empty.
  - Made the column `description` on table `Product` required. This step will fail if there are existing NULL values in that column.
  - Made the column `imageUrl` on table `Product` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "OrderStatus_new" AS ENUM ('PENDING', 'IN_PREPARATION', 'FINISHED');
ALTER TABLE "Order" ALTER COLUMN "status" TYPE "OrderStatus_new" USING ("status"::text::"OrderStatus_new");
ALTER TYPE "OrderStatus" RENAME TO "OrderStatus_old";
ALTER TYPE "OrderStatus_new" RENAME TO "OrderStatus";
DROP TYPE "OrderStatus_old";
COMMIT;

-- DropForeignKey
ALTER TABLE "Product" DROP CONSTRAINT "Product_menuCategoryId_fkey";

-- DropForeignKey
ALTER TABLE "Product" DROP CONSTRAINT "Product_restaurantID_fkey";

-- AlterTable
ALTER TABLE "MenuCategory" ALTER COLUMN "createdAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "OrderProduct" DROP COLUMN "cretatedAt",
DROP COLUMN "restaurantId",
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "Product" DROP COLUMN "restaurantID",
ADD COLUMN     "restaurantId" TEXT NOT NULL,
ALTER COLUMN "description" SET NOT NULL,
DROP COLUMN "ingredients",
ADD COLUMN     "ingredients" TEXT[],
ALTER COLUMN "imageUrl" SET NOT NULL,
ALTER COLUMN "createdAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_restaurantId_fkey" FOREIGN KEY ("restaurantId") REFERENCES "Restaurant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_menuCategoryId_fkey" FOREIGN KEY ("menuCategoryId") REFERENCES "MenuCategory"("id") ON DELETE CASCADE ON UPDATE CASCADE;
