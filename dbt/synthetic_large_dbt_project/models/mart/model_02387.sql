{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02041') }}
)
select id, 'model_02387' as name from sources
