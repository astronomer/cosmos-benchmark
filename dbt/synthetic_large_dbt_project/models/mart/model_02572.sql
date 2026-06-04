{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01613') }}
)
select id, 'model_02572' as name from sources
