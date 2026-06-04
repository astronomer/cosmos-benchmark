{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02076') }},
        {{ ref('model_01524') }},
        {{ ref('model_01948') }}
)
select id, 'model_02697' as name from sources
