{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01705') }}
)
select id, 'model_02273' as name from sources
