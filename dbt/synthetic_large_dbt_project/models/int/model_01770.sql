{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00805') }},
        {{ ref('model_01476') }},
        {{ ref('model_01061') }}
)
select id, 'model_01770' as name from sources
