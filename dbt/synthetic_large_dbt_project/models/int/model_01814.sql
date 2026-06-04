{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01443') }},
        {{ ref('model_01295') }},
        {{ ref('model_01464') }}
)
select id, 'model_01814' as name from sources
