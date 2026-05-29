{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01250') }},
        {{ ref('model_00815') }},
        {{ ref('model_01281') }}
)
select id, 'model_01784' as name from sources
