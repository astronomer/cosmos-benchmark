{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01744') }},
        {{ ref('model_02235') }},
        {{ ref('model_01993') }}
)
select id, 'model_02816' as name from sources
