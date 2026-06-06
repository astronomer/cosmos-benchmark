{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01238') }},
        {{ ref('model_01221') }},
        {{ ref('model_01458') }}
)
select id, 'model_01502' as name from sources
