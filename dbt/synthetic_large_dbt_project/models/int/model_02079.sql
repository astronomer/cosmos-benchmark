{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01348') }},
        {{ ref('model_01382') }}
)
select id, 'model_02079' as name from sources
