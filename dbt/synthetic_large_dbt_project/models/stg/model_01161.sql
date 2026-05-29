{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00559') }},
        {{ ref('model_00138') }},
        {{ ref('model_00402') }}
)
select id, 'model_01161' as name from sources
