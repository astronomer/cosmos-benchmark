{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02038') }}
)
select id, 'model_02959' as name from sources
