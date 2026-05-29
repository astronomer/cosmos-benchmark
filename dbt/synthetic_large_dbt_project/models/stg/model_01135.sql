{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00544') }},
        {{ ref('model_00090') }},
        {{ ref('model_00190') }}
)
select id, 'model_01135' as name from sources
