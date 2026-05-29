{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01069') }},
        {{ ref('model_00919') }},
        {{ ref('model_00960') }}
)
select id, 'model_01984' as name from sources
